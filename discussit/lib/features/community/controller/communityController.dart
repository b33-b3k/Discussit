import 'dart:io';

import 'package:discussit/core/constants.dart';
import 'package:discussit/core/failure.dart';
import 'package:discussit/core/providers/firebase_providers.dart';
import 'package:discussit/core/providers/storage_repo_provider.dart';
import 'package:discussit/core/utils.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/community/repository/community_repo.dart';
import 'package:discussit/features/community/screens/create_community_screen.dart';
import 'package:discussit/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});
final CommunityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

final getCommunitybyNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final class CommunityController extends StateNotifier<bool> {
  //state notifier to notify for change
  final CommunityRepository
      _communityRepository; //this is used to create a new provider in ccscreen
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController(
      {required StorageRepository storageRepository,
      required CommunityRepository communityRepository,
      required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? "";
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      moderators: [uid],
      createdBy: name,
      createdAt: DateTime.now(),
      description: 'bio',
      posts: [],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
        // used to display failure if l and success if r and execute the function
        (l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community created successfully!');
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider);
    Either<Failure, void> res;
    if (community.members.contains(user?.uid)) {
      res =
          await _communityRepository.leaveCommunity(community.name, user!.uid);
      showSnackBar(context, 'Left Community');

      return;
    } else {
      res = await _communityRepository.joinCommunity(community.name, user!.uid);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => showSnackBar(context, 'Joined Community'));
    }
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)?.uid ?? "";
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(
      {required File? profilePic,
      required File? bannerFile,
      required BuildContext context,
      required Community community}) async {
    state = true;
    if (profilePic != null) {
      final res = await _storageRepository.storeFile(
          path: '/communities/profile', id: community.name, file: profilePic);

      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(avatar: r));
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          //communities/banner/memes
          path: '/communities/banner',
          id: community.name,
          file: bannerFile);

      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(banner: r));
    }
    state = false;

    final res = await _communityRepository.editCommunity(community);
    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    final res = await _communityRepository.addMods(communityName, uids);

    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }
}
