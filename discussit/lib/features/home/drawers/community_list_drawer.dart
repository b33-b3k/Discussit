import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/core/common/siginbutton.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/controller/communityController.dart';
import 'package:discussit/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityList extends ConsumerWidget {
  const CommunityList({super.key});

  void navToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/createCommunity');
  }

  void navToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/d/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isGuest = !user!.isAuthenticated;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          isGuest
              ? const SignInButton(
                  isFromLogin: false,
                )
              : ListTile(
                  title: const Text("Create a Community"),
                  leading: const Icon(Icons.add),
                  onTap: () => navToCreateCommunity(context),
                ),
          const Divider(),
          if (!isGuest)
            ref.watch(userCommunitiesProvider).when(
                  data: (communities) => Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (BuildContext context, int index) {
                        final community = communities[index];
                        return ListTile(
                          title: Text('d/${community.name}'),
                          onTap: () {
                            navToCommunity(context, community);
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                        );
                      },
                    ),
                  ),
                  error: (error, StackTrace) {
                    Errortext(error: "hello${error.toString()}");

                    throw error;
                  },
                  loading: () => const Loader(),
                )
        ],
      )),
    );
  }
}
