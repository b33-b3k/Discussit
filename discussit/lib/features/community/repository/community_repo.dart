import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discussit/core/failure.dart';
import 'package:discussit/core/firebase_constants.dart';
import 'package:discussit/core/providers/firebase_providers.dart';
import 'package:discussit/core/typedef.dart';
import 'package:discussit/features/community/screens/create_community_screen.dart';
import 'package:discussit/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});
final CommunityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw "Community with same name already exists";
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities
        .where("members", arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Community.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
