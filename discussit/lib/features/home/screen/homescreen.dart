import 'package:discussit/core/constants/constants.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/home/delegates/search_community_delegate.dart';
import 'package:discussit/features/home/drawers/community_list_drawer.dart';
import 'package:discussit/features/home/drawers/profile_drawer.dart';
import 'package:discussit/theme/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return SafeArea(
      top: false,
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
        body: Constants
            .tabWidgets[_page], //fetch widget and display each using page
        //0 feed 1 addPost
        drawer: CommunityList(),
        endDrawer: const ProfileDrawer(),
        bottomNavigationBar: CupertinoTabBar(
          activeColor: currentTheme.iconTheme.color,
          backgroundColor: currentTheme.backgroundColor,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_outlined), label: "Add"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                label: "Notifications"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: "Profile"),
          ],
          onTap: onPageChanged,
          currentIndex: _page,
        ),
      ),
    );
  }
}
