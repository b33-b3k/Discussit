import 'package:any_link_preview/any_link_preview.dart';
import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/core/constants/constants.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/controller/communityController.dart';
import 'package:discussit/features/post/controller/postController.dart';
import 'package:discussit/features/post/repository/postRepo.dart';
import 'package:discussit/models/post_model.dart';
import 'package:discussit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    final isGuest = !user!.isAuthenticated;
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(color: currentTheme.drawerTheme.backgroundColor),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 8)
                              .copyWith(right: 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Routemaster.of(context)
                                          .push('/u/${post.communityName}');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundImage: NetworkImage(
                                            post.communityProfilePic),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Routemaster.of(context).push(
                                                '/d/${post.communityName}');
                                          },
                                          child: Text(
                                            'd/${post.communityName}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Routemaster.of(context)
                                                .push('/u/${post.uid}');
                                          },
                                          child: Text(
                                            'u/${post.username}',
                                            style: const TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w100),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user?.uid)
                                IconButton(
                                    onPressed: () {
                                      deletePost(ref, context);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                            ],
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionVertical,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  isGuest
                                      ? null
                                      : ref
                                          .watch(postRepositoryProvider)
                                          .upvote(post, user!.uid);
                                },
                                icon: Icon(Constants.up,
                                    size: 30,
                                    color: post.upvotes.contains(user?.uid)
                                        ? Pallete.redColor
                                        : null),
                              ),
                              Text(
                                  "${post.upvotes.length - post.downvotes.length == 0 ? "Vote" : post.upvotes.length - post.downvotes.length}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                onPressed: () {
                                  isGuest
                                      ? null
                                      : ref
                                          .watch(postRepositoryProvider)
                                          .downvote(post, user!.uid);
                                },
                                icon: Icon(Constants.down,
                                    size: 30,
                                    color: post.downvotes.contains(user?.uid)
                                        ? Pallete.blueColor
                                        : null),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Routemaster.of(context)
                                            .push('/post/${post.id}/comments');
                                      },
                                      icon: const Icon(
                                        Icons.insert_comment_outlined,
                                        size: 30,
                                      )),
                                  Text(
                                      "${post.commentCount == 0 ? "Comment" : post.commentCount}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  ref
                                      .watch(getCommunitybyNameProvider(
                                          post.communityName))
                                      .when(
                                        data: (data) {
                                          if (data.moderators
                                              .contains(user?.uid)) {
                                            return IconButton(
                                                onPressed: () {
                                                  deletePost(ref, context);
                                                },
                                                icon: const Icon(
                                                  Icons.add_moderator_outlined,
                                                  size: 30,
                                                ));
                                          }
                                          return const SizedBox();
                                        },
                                        error: ((error, stackTrace) {
                                          return Errortext(
                                            error: error.toString(),
                                          );
                                        }),
                                        loading: () => const Loader(),
                                      ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.add_moderator_outlined,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
