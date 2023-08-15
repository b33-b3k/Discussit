import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discussit/core/constants/constants.dart';
import 'package:discussit/core/failure.dart';
import 'package:discussit/core/firebase_constants.dart';
import 'package:discussit/core/providers/firebase_providers.dart';
import 'package:discussit/core/typedef.dart';
import 'package:discussit/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firestore = FirebaseFirestore.instance;
final AuthRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(GoogleSignInProvider)));

class AuthRepository {
  // ignore: unused_field
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential;
      if (isFromLogin) {
        userCredential = await _auth.signInWithCredential(credential);
      } else {
        userCredential = (await _auth.currentUser?.linkWithCredential(
            credential))!; //link credentials of guest with new
      }
      late UserModel userModel;
      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          userModel = UserModel(
            name: userCredential.user!.displayName ?? "Anonymous",
            email: userCredential.user!.email ?? " ",
            profilepic:
                userCredential.user!.photoURL ?? Constants.avatarDefault,
            banner: Constants.bannerDefault,
            uid: userCredential.user!.uid,
            bio: "bio",
            isAuthenticated: true,
            karma: 0,
          );
          await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        } else {
          userModel = await getUserData(userCredential.user!.uid).first;
          print(userModel);
        }
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (E) {
      return left(Failure(E.toString()));
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();
      late UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: 'Guest',
          email: userCredential.user!.email ?? " ",
          profilepic: Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          bio: "bio",
          isAuthenticated: false,
          karma: 0,
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (E) {
      return left(Failure(E.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) {
      if (event.data() != null) {
        return UserModel.fromMap(event.data()! as Map<String, dynamic>);
      } else {
        // Return a default UserModel or handle the null case as needed.
        return UserModel(
          name: "Anonymous",
          email: " ",
          profilepic: Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: uid,
          bio: "bio",
          isAuthenticated: true,
          karma: 0,
        ); // Replace UserModel() with your default constructor.
      }
    });
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
