import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
        child: Column(
      children: [
        CircleAvatar(
          // backgroundImage: NetworkImage(user!.profilepic),
          radius: 70,
        ),
        SizedBox(
          height: 10,
        ),
        Text("d/${user?.name}", style: Theme.of(context).textTheme.headline6),
        Divider(
          thickness: 2,
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Profile"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.logout,
            color: Pallete.redColor,
          ),
          title: Text("Logout"),
          onTap: () {
            logOut(ref);
            // ref.read(authControllerProvider.notifier).signOut();
          },
        ),
        Switch.adaptive(
          value: true,
          onChanged: (value) {},
        )
      ],
    ));
  }
}
