import 'package:discussit/core/common/siginbutton.dart';
import 'package:discussit/core/constants.dart';
import 'package:discussit/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Login extends ConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 40,
          alignment: Alignment.center,
        ),
        actions: [
          TextButton(
            child: Text("Skip", style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(children: [
              const SizedBox(height: 80),
              Text(
                "Welcome to Discuss It",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  Constants.logoPath,
                ),
              ),
              const SizedBox(height: 30),
              SignInButton()
            ]),
    );
  }
}

class Loader extends ConsumerWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(child: CircularProgressIndicator());
  }
}
