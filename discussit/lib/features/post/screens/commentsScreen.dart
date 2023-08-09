import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/post/controller/postController.dart';
import 'package:discussit/features/post/screens/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;

  CommentScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data) {
            return Column(
              children: [
                PostCard(post: data),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: "Add a comment",
                    filled: true,
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.comment),
                  ),
                ),
              ],
            );
          },
          error: ((error, stackTrace) => Errortext(error: error.toString())),
          loading: () => const Loader()),
    );
  }
}
