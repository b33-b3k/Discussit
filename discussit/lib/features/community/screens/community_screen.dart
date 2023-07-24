import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/repository/community_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  // localhost/d/memes

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: ref.watch(getCommunitybyNameProvider(name)).when(
            data: (community) => NestedScrollView(
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      title: Text(community.name),
                      floating: true,
                      expandedHeight: 150,
                      flexibleSpace: Stack(children: [
                        Positioned.fill(child: Image.network(community.banner))
                      ]),
                      snap: true,
                    )
                  ];
                }),
                body: const Text("data")),
            error: ((error, stackTrace) => Errortext(error: error.toString())),
            loading: () => const Loader()));
  }
}
