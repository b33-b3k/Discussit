import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/home/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import "package:discussit/features/auth/screen/loginScreen.dart";

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: Login()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
});
