import "package:flutter/material.dart";
import "package:routemaster/routemaster.dart";

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({
    required this.name,
    super.key,
  });
  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mod Tools"),
      ),
      body: Column(children: [
        ListTile(
          leading: Icon(Icons.add_moderator),
          title: const Text("Add Mods"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.add_moderator),
          title: const Text("Edit Community"),
          onTap: () => navigateToModTools(context),
        )
      ]),
    );
  }
}
