import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/screens/add_mod_screen.dart';
import 'package:discussit/features/community/screens/community_screen.dart';
import 'package:discussit/features/community/screens/create_community_screen.dart';
import 'package:discussit/features/community/screens/editCommunity.dart';
import 'package:discussit/features/community/screens/modtools.dart';
import 'package:discussit/features/home/screen/homescreen.dart';
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
});
