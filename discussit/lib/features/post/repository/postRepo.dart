import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discussit/core/failure.dart';
import 'package:discussit/core/firebase_constants.dart';
import 'package:discussit/core/providers/firebase_providers.dart';
import 'package:discussit/core/typedef.dart';
import 'package:discussit/models/community_model.dart';
import 'package:discussit/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:discussit/models/comment_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    //list of posts where communityname order by date and taking snapshot and converting it into list
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  //delete post

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //upvote
  void upvote(Post post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downvote(Post post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map((event) {
      if (event.data() == null) {
        throw Exception("Document not found or null");
      }
      return Post.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  FutureVoid addComment(Comments comment) async {
    try {
      await _comments.doc(comment.id).set(
            comment.toMap(),
          );
      return right(
        _posts.doc(comment.postId).update({
          'commentCount': FieldValue.increment(1),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comments>> getCommentsofPosts(String postId) {
    print('Fetching comments for postId: $postId');
    return _posts
        .where('id', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) {
      print('Fetched event: $event');
      return event.docs
          .map((e) => Comments.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
