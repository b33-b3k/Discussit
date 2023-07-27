import 'package:discussit/core/providers/storage_repo_provider.dart';
import 'package:discussit/core/utils.dart';
import 'package:discussit/features/auth/screen/loginScreen.dart';
import 'package:discussit/features/community/controller/communityController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final CommunityRepository = ref.watch(CommunityRepositoryProvider);
  final StorageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
      storageRepository: StorageRepository,
      communityRepository: CommunityRepository,
      ref: ref);
});

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    final communityName = communityNameController.text.trim();
    if (communityName.isEmpty) {
      showSnackBar(context, "Community name cannot be empty");
      return;
    }
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(communityName, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Community"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Text("Community Name")),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: communityNameController,
                  decoration: const InputDecoration(
                      hintText: "d/CommunityName",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(18)),
                  maxLength: 21,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => createCommunity(),
                  child: Text(
                    "Create Community",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ]),
            ),
    );
  }
}
