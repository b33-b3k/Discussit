import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/screens/community_screen.dart';
import 'package:discussit/features/community/screens/create_community_screen.dart';
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
      )),
});
