import 'dart:io';

import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/core/constants/constants.dart';
import 'package:discussit/core/utils.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/user_profile/controller/user_profile_controller.dart';
import 'package:discussit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;

  EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    // TODO: implement initState
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    super.dispose();
  }

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

  void save() {
    ref.read(UserProfileControllerProvider.notifier).editProfile(
        profilePic: profileFile,
        bannerFile: bannerFile,
        context: context,
        name: nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(UserProfileControllerProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (user) => Scaffold(
            backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
            appBar: AppBar(
              title: const Text("Edit Profile"),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () {
                      save();
                    },
                    child: const Text("Save"))
              ],
            ),
            body: isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
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
                                      border: Border.all(color: Colors.white)),
                                  child: bannerFile != null
                                      ? Image.file(bannerFile!)
                                      : user.banner == Constants.bannerDefault
                                          ? const Center(
                                              child: Icon(
                                                  Icons.camera_alt_outlined))
                                          : Image.network(user.banner),
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
                                              user.profilepic,
                                            ),
                                          )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Name",
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                              hintStyle: TextStyle(color: Colors.white)),
                          onChanged: (value) {},
                        )
                      ],
                    ),
                  )
                : const Loader()),
        error: (error, stackTrace) => Errortext(error: error.toString()),
        loading: () => const Loader());
  }
}
