import 'package:chat_app/controllers/firebase_auth_controller.dart';
import 'package:chat_app/data_sources/firebase_services.dart';
import 'package:chat_app/resources/widgets/home/body_home.dart';
import 'package:chat_app/resources/widgets/home/header_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FireBaseServices fireBaseServices = FireBaseServices();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<FirebaseAuthController>().appUser;
    // Muốn lấy user từ controller firebaseAuth

    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
            child: HeaderHome(user: user!)),
        Expanded(
            child: BodyHome(fireBaseServices: fireBaseServices, user: user)),
      ],
    )));
  }
}
