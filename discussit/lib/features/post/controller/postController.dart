import 'dart:io';

import 'package:discussit/core/enums/enums.dart';
import 'package:discussit/core/providers/storage_repo_provider.dart';
import 'package:discussit/core/utils.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/post/repository/postRepo.dart';
import 'package:discussit/features/user_profile/controller/user_profile_controller.dart';
import 'package:discussit/models/comment_model.dart';
import 'package:discussit/models/community_model.dart';
import 'package:discussit/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);

  return PostController(
      postRepository: postRepository,
      storageRepository: storageRepository,
      ref: ref);
});
final userPostProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});
final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  final commentsStream = postController.fetchPostComments(postId);

  commentsStream.listen((data) {
    print("Commentt Data: $data");
  });

  return commentsStream;
});

class PostController extends StateNotifier<bool> {
  //state notifier to notify for change
  final PostRepository
      _postRepository; //this is used to create a new provider in ccscreen
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController(
      {required StorageRepository storageRepository,
      required PostRepository postRepository,
      required Ref ref})
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareLinkPost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required String Link}) async {
    state = true;
    _ref
        .read(UserProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);
    final uid = _ref.read(userProvider)?.uid ?? "";
    String postId = Uuid().v1();
    final user = _ref.read(userProvider)?.name ?? "";

    final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user,
        uid: uid,
        link: Link,
        type: 'link',
        description: Link,
        createdAt: DateTime.now());

    print("postId:$postId");

    final res = await _postRepository.addPost(post);
    _ref
        .read(UserProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Post added successfully");
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required File? file}) async {
    state = true;
    final imageUrl = "";
    String postId = Uuid().v1();
    final user = _ref.read(userProvider);
    final imageResult = await _storageRepository.storeFile(
        path: 'posts/${selectedCommunity.name}', id: postId, file: file);

    imageResult.fold((l) => showSnackBar(context, l.message), (r) async {
      showSnackBar(context, "Post added successfully");
      Routemaster.of(context).pop();
      imageUrl == r;
    });
    final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        link: imageUrl,
        username: user?.name ?? "",
        uid: user!.uid,
        type: 'image',
        createdAt: DateTime.now());

    final res = await _postRepository.addPost(post);
    state = false;
    _ref
        .read(UserProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.imagePost);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Post added successfully");
      Routemaster.of(context).pop();
    });
  }

  void shareTextPost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required String description}) async {
    state = true;
    String postId = Uuid().v1();
    final user = _ref.read(userProvider);
    final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user?.name ?? "",
        uid: user!.uid,
        type: 'text',
        description: description,
        createdAt: DateTime.now());

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Post added successfully");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    _ref
        .read(UserProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Post deleted successfully");
      Routemaster.of(context).pop();
    });
  }

  void upvote(Post post) async {
    final uid = _ref.read(userProvider)?.uid ?? "";
    _postRepository.upvote(post, uid);
  }

  void downvote(Post post) async {
    final uid = _ref.read(userProvider)?.uid ?? "";
    _postRepository.downvote(post, uid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider);
    String commentId = const Uuid().v1();
    Comments comment = Comments(
        id: commentId,
        text: text,
        postId: post.id,
        createdAt: DateTime.now(),
        username: user!.name,
        profilePic: user.profilepic);
    final res = await _postRepository.addComment(comment);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Comment added successfully");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Comments>> fetchPostComments(String postId) {
    if (postId.isNotEmpty) {
      print("success");
      return _postRepository.getCommentsofPosts(postId);
    } else {
      // Return an empty stream instead of an empty list
      return Stream.value([]);
    }
  }
}
