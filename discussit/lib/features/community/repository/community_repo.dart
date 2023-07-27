import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discussit/core/failure.dart';
import 'package:discussit/core/firebase_constants.dart';

import 'package:discussit/core/typedef.dart';
import 'package:discussit/models/community_model.dart';

import 'package:fpdart/fpdart.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        return left(Failure("Community already exists"));
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update(
        {
          'members': FieldValue.arrayUnion([userId])
        },
      ));
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update(
        {
          'members': FieldValue.arrayRemove([userId])
        },
      ));
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities
        .where("members", arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Community(
          id: data['id'] as String,
          name: data['name'] as String,
          banner: data['banner'] as String,
          avatar: data['avatar'] as String,
          members: List<String>.from(data['members'] as List<dynamic>),
          moderators: List<String>.from(data['moderators'] as List<dynamic>),
          createdBy: data['createdBy'] as String,
          createdAt:
              DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
          description: data['description'] as String,
          posts: List<String>.from(data['posts'] as List<dynamic>),
        );
      }).toList();
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map((snapshot) =>
        Community.fromMap(snapshot.data() as Map<String, dynamic>));
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<Community> communities = [];
      event.docs.forEach((element) {
        communities
            .add(Community.fromMap(element.data() as Map<String, dynamic>));
      });
      return communities;
    });
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(_communities.doc(communityName).update({
        'mods': uids,
      }));
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
