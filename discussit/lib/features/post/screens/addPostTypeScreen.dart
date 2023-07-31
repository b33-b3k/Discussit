import 'dart:io';

import 'package:discussit/core/common/error_text.dart';
import 'package:discussit/core/constants/constants.dart';
import 'package:discussit/core/utils.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/controller/communityController.dart';
import 'package:discussit/models/community_model.dart';
import 'package:discussit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  File? bannerFile;
  File? profileFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    // Clean up the controller when disposing of the screen
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Share",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
        title: Text("Add ${widget.type} post"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            if (isTypeImage)
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
                        : const Center(child: Icon(Icons.camera_alt_outlined))),
              ),
            const SizedBox(
              height: 10,
            ),
            if (isTypeText)
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Title",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(18),
                  hintStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {},
              ),
            const SizedBox(
              height: 10,
            ),
            if (isTypeText)
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter Description here",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(18),
                    hintStyle: TextStyle(color: Colors.white)),
                maxLines: 5,
                maxLength: 30,
                onChanged: (value) {},
              ),
            const SizedBox(
              height: 10,
            ),
            if (isTypeLink)
              TextField(
                controller: linkController,
                decoration: InputDecoration(
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter link here",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(18),
                    hintStyle: TextStyle(color: Colors.white)),
                onChanged: (value) {},
              ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: Text("Select Community"),
            ),
            ref.watch(userCommunitiesProvider).when(
                data: (data) {
                  communities = data;
                  if (data.isEmpty) {
                    return const SizedBox();
                  }
                  return DropdownButton(
                      value: selectedCommunity ?? data[0],
                      items: data
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCommunity = val;
                        });
                      });
                },
                error: (error, StackTrace) =>
                    Errortext(error: error.toString()),
                loading: () => const Loader())
          ],
        ),
      ),
    );
  }
}
