import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/core/constants.dart';
import 'package:discussit/core/utils.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/controller/communityController.dart';
import 'package:discussit/features/community/repository/community_repo.dart';
import 'package:discussit/features/community/screens/create_community_screen.dart';
import 'package:discussit/models/community_model.dart';
import 'package:discussit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({required this.name, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
  void selectBannerImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        bannerFile = File(result.files.first.path!);
      });
    }
  }

  void selectProfileFile() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        profileFile = File(result.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
        profilePic: profileFile,
        bannerFile: bannerFile,
        context: context,
        community: community);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return ref.watch(getCommunitybyNameProvider(widget.name)).when(
        data: (community) => Scaffold(
              backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
              appBar: AppBar(
                title: const Text("Edit Community"),
                centerTitle: false,
                actions: [
                  TextButton(
                      onPressed: () => save(community),
                      child: const Text("Save"))
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    selectBannerImage();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : community.banner ==
                                                Constants.bannerDefault
                                            ? const Center(
                                                child: Icon(
                                                    Icons.camera_alt_outlined))
                                            : Image.network(community.banner),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  child: GestureDetector(
                                      onTap: () => selectProfileFile(),
                                      child: profileFile != null
                                          ? CircleAvatar(
                                              radius: 36,
                                              backgroundImage: FileImage(
                                                profileFile!,
                                              ))
                                          : CircleAvatar(
                                              radius: 36,
                                              backgroundImage: NetworkImage(
                                                community.avatar,
                                              ),
                                            )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
        error: (error, stackTrace) => Errortext(error: error.toString()),
        loading: () => const Loader());
  }
}
