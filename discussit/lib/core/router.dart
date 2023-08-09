import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/screens/add_mod_screen.dart';
import 'package:discussit/features/community/screens/community_screen.dart';
import 'package:discussit/features/community/screens/create_community_screen.dart';
import 'package:discussit/features/community/screens/editCommunity.dart';
import 'package:discussit/features/community/screens/modtools.dart';
import 'package:discussit/features/home/screen/homescreen.dart';
import 'package:discussit/features/post/screens/addPostTypeScreen.dart';
import 'package:discussit/features/post/screens/commentsScreen.dart';
import 'package:discussit/features/user_profile/screens/user_profile_screen.dart';
import 'package:discussit/features/user_profile/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: Login()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/createCommunity': (_) => const MaterialPage(child: CreateCommunityScreen()),
  '/d/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters['name']!,
        ),
      ),
  '/mod-tools/:name': (routeData) => MaterialPage(
          child: ModToolsScreen(
        name: routeData.pathParameters['name']!,
      )),
  '/edit-community/:name': (routeData) => MaterialPage(
          child: EditCommunityScreen(
        name: routeData.pathParameters['name']!,
      )),
  '/add-mods/:name': (routeData) => MaterialPage(
          child: AddModsScreen(
        name: routeData.pathParameters['name']!,
      )),
  '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
        uid: routeData.pathParameters['uid']!,
      )),
  '/u/edit-profile/:uid': (routeData) {
    final uid = routeData.pathParameters['uid'];
    if (uid != null) {
      return MaterialPage(
        child: EditProfileScreen(
          uid: uid,
        ),
      );
    } else {
      // Handle the case when the uid is null, for example, show an error message or redirect to another screen.
      return const MaterialPage(
        child: Scaffold(
          body: Center(
            child: Text('Error: User ID is null.'),
          ),
        ),
      );
    }
  },
  '/add-post/:type': (routeData) => MaterialPage(
          child: AddPostTypeScreen(
        type: routeData.pathParameters['type']!,
      )),
  '/post/:postId/comments': (route) => MaterialPage(
      child: CommentScreen(postId: route.pathParameters['postId']!)),
});
