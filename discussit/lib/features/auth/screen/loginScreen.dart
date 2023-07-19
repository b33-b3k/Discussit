import 'package:discussit/core/common/siginbutton.dart';
import 'package:discussit/core/constants.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Column(children: [
        const SizedBox(height: 30),
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
