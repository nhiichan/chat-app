import 'package:chat_app/controllers/firebase_auth_controller.dart';
import 'package:chat_app/views/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Bắt buộc khởi tạo nếu không sẽ báo lỗi!!!
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Chứa nhiều provider
        ChangeNotifierProvider<FirebaseAuthController>(
            create: (context) => FirebaseAuthController())
        // Một cái Controller này sẽ lưu những gì?
        // Tất cả các trường của một instance mình 
        // đã khai báo bao gồm trạng thái Auth, user, có đang loading không
      ],
      builder: (context, child) => MaterialApp(
        title: "My Chat App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Baloo2",
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.white
        ),
        home: const MainScreen()
      )
    );
  }
}
