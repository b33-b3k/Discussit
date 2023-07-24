import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/repository/community_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityList extends ConsumerWidget {
  const CommunityList({super.key});

  void navToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/createCommunity');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
            title: const Text("Create a Community"),
            leading: const Icon(Icons.add),
            onTap: () => navToCreateCommunity(context),
          ),
          const Divider(),
          ref.watch(userCommunitiesProvider).when(
                data: (communities) => Expanded(
                  child: ListView.builder(
                    itemCount: communities.length,
                    itemBuilder: (BuildContext context, int index) {
                      final community = communities[index];
                      return ListTile(
                        title: Text('d/${community.name}'),
                        onTap: () {
                          Routemaster.of(context)
                              .push('/community/${community.name}');
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),
                        ),
                      );
                    },
                  ),
                ),
                error: (error, StackTrace) =>
                    Errortext(error: error.toString()),
                loading: () => const Loader(),
              )
        ],
      )),
    );
  }
}
