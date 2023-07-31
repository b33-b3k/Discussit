import 'package:discussit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double iconSize = 60;
    double cardHeightWidth = 120;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            navigateToType(context, 'image');
          },
          child: SizedBox(
            height: 120,
            width: 120,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 16,
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            navigateToType(context, 'text');
          },
          child: SizedBox(
            height: 120,
            width: 120,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 16,
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.download_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            navigateToType(context, 'link');
          },
          child: SizedBox(
            height: 120,
            width: 120,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 16,
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.link_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
