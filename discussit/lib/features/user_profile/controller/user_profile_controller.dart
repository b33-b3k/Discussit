import 'dart:io';

import 'package:discussit/core/enums/enums.dart';
import 'package:discussit/core/providers/storage_repo_provider.dart';
import 'package:discussit/core/utils.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/user_profile/repository/user_profile_repo.dart';
import 'package:discussit/models/post_model.dart';
import 'package:discussit/models/user_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

final UserProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(UserProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
      storageRepository: storageRepository,
      userProfileRepository: userProfileRepository,
      ref: ref);
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(UserProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  //state notifier to notify for change
  final UserProfileRepository
      _userProfileRepository; //this is used to create a new provider in ccscreen

  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController(
      {required StorageRepository storageRepository,
      required UserProfileRepository userProfileRepository,
      required Ref ref})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma) async {
    var user = _ref.read(userProvider); //i changed this
    user = user?.copyWith(karma: user.karma + karma.karma);

    final res = await _userProfileRepository.updateUserKarma(user!);
    res
        .fold((l) => null, (r) => _ref.read(userProvider.notifier))
        ?.update((state) => user);
  }

  void editProfile(
      {required File? profilePic,
      required File? bannerFile,
      required BuildContext context,
      required String name}) async {
    state = true;
    var user = _ref.read(userProvider);
    if (profilePic != null) {
      final res = await _storageRepository.storeFile(
          path: '/users/profile', id: user!.uid, file: profilePic);

      res.fold((l) => showSnackBar(context, l.message),
          (r) => user = user?.copyWith(profilepic: r)); //r is download url
    }

    if (bannerFile != null) {
      var res = await _storageRepository.storeFile(
          //communities/banner/memes
          path: '/users/banner',
          id: user!.uid,
          file: bannerFile);

      res.fold((l) => showSnackBar(context, l.message),
          (r) => user = user?.copyWith(banner: r));
    }
    state = false;
    user = user?.copyWith(name: name);
    // Update user in the state
    _ref.read(userProvider.notifier).update((state) => user);

    final res = await _userProfileRepository.updateProfile(user!);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }
}
