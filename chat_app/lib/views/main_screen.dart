import 'package:chat_app/controllers/firebase_auth_controller.dart';
import 'package:chat_app/views/home_screen.dart';
import 'package:chat_app/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/sign_in_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.watch<FirebaseAuthController>().authStatus;
    // Lấy tình trạng đăng nhập từ controller
    // Nếu đăng nhập rồi thì vào HomeScreen
    // Chưa đăng nhập thì vào màn hình đăng nhập
    // None thì vào màn hình chờ loading của ứng dụng - Splash Screen

    switch (status) {
      case AuthStatus.authenticate:
        return const HomeScreen();
      case AuthStatus.unauthenticate:
        return const SignInScreen();
      default:
        return const SplashScreen();
    }
  }
}
