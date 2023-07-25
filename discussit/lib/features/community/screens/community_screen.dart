import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/repository/community_repo.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

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
                            community.moderators.contains(user?.uid)
                                ? OutlinedButton(
                                    onPressed: () =>
                                        navigateToModTools(context),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                    ),
                                    child: const Text(" Settings "))
                                : OutlinedButton(
                                    onPressed: () =>
                                        navigateToModTools(context),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                body: const Text("data")),
            error: ((error, stackTrace) => Errortext(error: error.toString())),
            loading: () => const Loader()));
  }
}
