import 'package:chat_app/resources/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(tag: amzChatIcon, child: SizedBox(
          height: 202,
          width: 202,
          child: Image.asset(amzChatIcon),
        )),
      ),
    );
  }
}
