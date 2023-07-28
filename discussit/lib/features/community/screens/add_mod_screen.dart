import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/controller/communityController.dart';
import 'package:discussit/features/community/screens/create_community_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({required this.name, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int ctr = 0; //check no of times the checkbox was rebuild

  void addUids(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUids(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addMods(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              onPressed: () {
                saveMods();
              },
              icon: Icon(Icons.done))
        ]),
        body: ref.watch(getCommunitybyNameProvider(widget.name)).when(
            data: (community) {
              return ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (BuildContext context, int index) {
                  final member = community.members[index];
                  return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.moderators.contains(member) && ctr == 0) {
                          uids.add(member);
                        }
                        ctr++;

                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (value) {
                            if (value == true) {
                              addUids(user.uid);
                            } else {
                              removeUids(user.uid);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: (error, stackTrace) {
                        return Errortext(
                          error: error.toString(),
                        );
                      },
                      loading: () => const Loader());
                },
              );
            },
            error: (error, stackTrace) {
              return Errortext(
                error: error.toString(),
              );
            },
            loading: () => const Loader()));
  }
}
