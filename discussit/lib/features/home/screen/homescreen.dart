import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/home/delegates/search_community_delegate.dart';
import 'package:discussit/features/home/drawers/community_list_drawer.dart';
import 'package:discussit/features/home/drawers/profile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => displayDrawer(context),
            );
          }),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                      context: context, delegate: SearchCommunityDelegate(ref));
                }),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  displayEndDrawer(context);
                },
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user?.profilepic ?? "",
                  ),
                ),
              );
            })
          ],
        ),
        drawer: CommunityList(),
        endDrawer: const ProfileDrawer(),
      ),
    );
  }
}
