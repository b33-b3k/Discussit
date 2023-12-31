import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/controller/communityController.dart';
import 'package:discussit/features/community/screens/create_community_screen.dart';
import 'package:discussit/features/post/screens/post_card.dart';
import 'package:discussit/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  // localhost/d/memes

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isGuest = !user!.isAuthenticated;

    return Scaffold(
        body: ref.watch(getCommunitybyNameProvider(name)).when(
            data: (community) => NestedScrollView(
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      title: Text(community.name),
                      floating: true,
                      expandedHeight: 150,
                      flexibleSpace: Stack(children: [
                        Positioned.fill(
                            child: Image.network(community.banner,
                                fit: BoxFit.cover))
                      ]),
                      snap: true,
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate([
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            radius: 36,
                            backgroundImage: NetworkImage(
                              community.avatar,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "d/${community.name}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            if (!isGuest)
                              community.moderators.contains(user.uid)
                                  ? OutlinedButton(
                                      onPressed: () =>
                                          navigateToModTools(context),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: const Text(" Settings "))
                                  : OutlinedButton(
                                      onPressed: () => joinCommunity(
                                          ref, community, context),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: Text(
                                          community.members.contains(user?.uid)
                                              ? "Joined"
                                              : " Join "),
                                    )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            "${community.members.length} members",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w100),
                          ),
                        ),
                      ])),
                    )
                  ];
                }),
                body: ref.watch(getCommunityPostsProvider(name)).when(
                    data: (data) {
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final post = data[index];
                            return PostCard(post: post);
                          });
                    },
                    error: ((error, stackTrace) {
                      return Errortext(error: error.toString());
                    }),
                    loading: () => const Loader())),
            error: ((error, stackTrace) => Errortext(error: error.toString())),
            loading: () => const Loader()));
  }
}
