import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
          body: ref.watch(getUserDataProvider(uid)).when(
              data: (user) => NestedScrollView(
                  headerSliverBuilder: ((context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        title: Text(user.name),
                        floating: true,
                        expandedHeight: 170,
                        flexibleSpace: Stack(children: [
                          Positioned.fill(
                              child: Image.network(user.banner,
                                  fit: BoxFit.fitHeight)),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding:
                                const EdgeInsets.all(20).copyWith(bottom: 5),
                            child: CircleAvatar(
                              radius: 36,
                              backgroundImage: NetworkImage(
                                user.profilepic,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              alignment: Alignment.bottomRight,
                              child: OutlinedButton(
                                  onPressed: () {
                                    Routemaster.of(context)
                                        .push('/u/edit-profile/${uid}');
                                    print(uid);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                  ),
                                  child: const Text(" Edit profile ")),
                            ),
                          )
                        ]),
                        snap: true,
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                            delegate: SliverChildListDelegate([
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "u/${user.name}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(
                              "${user.karma} karma ",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w100),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 20,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                          ),
                        ])),
                      )
                    ];
                  }),
                  body: const Text("data")),
              error: ((error, stackTrace) =>
                  Errortext(error: error.toString())),
              loading: () => const Loader())),
    );
  }
}
