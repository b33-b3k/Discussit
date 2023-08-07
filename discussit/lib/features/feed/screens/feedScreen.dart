import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/controller/communityController.dart';
import 'package:discussit/features/post/controller/postController.dart';
import 'package:discussit/features/post/screens/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(
        data: (communities) => ref.watch(userPostProvider(communities)).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final post = data[index];
                  return PostCard(
                    post: post,
                  );
                },
              );
            },
            error: ((error, stackTrace) {
              return Errortext(error: error.toString());
            }),
            loading: () => const Loader()),
        error: ((error, stackTrace) => Errortext(error: error.toString())),
        loading: () => const Loader());
  }
}
