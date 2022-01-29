import 'dart:io';

import 'package:chat_app/controllers/firebase_auth_controller.dart';
import 'package:chat_app/resources/constants.dart';
import 'package:chat_app/resources/utils/utils.dart';
import 'package:chat_app/resources/widgets/auth/auth_button.dart';
import 'package:chat_app/resources/widgets/change_profile/header_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChangeProfileScreen extends StatefulWidget {
  // phải dùng Stateful để có những hàm như dispose
  const ChangeProfileScreen({Key? key}) : super(key: key);

  @override
  _ChangeProfileScreenState createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  TextEditingController? newNameController;
  File? newAvatar;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // ignore: todo
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    newNameController = TextEditingController(
        text: context.watch<FirebaseAuthController>().appUser!.displayName);
    // Giá trị khởi tạo ban đầu cho cái Controller là displayName luôn!
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    newNameController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<FirebaseAuthController>().appUser;
    return Stack(
      children: [
        Scaffold(
            body: SafeArea(
                child: Column(
          children: [
            const HeaderEdit(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    GestureDetector(
                        onTap: () {
                          Utils.showPickImageModelBottomSheet(
                            context,
                            onPickImage: (image) {
                              setState(() {
                                newAvatar = image;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            newAvatar != null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(newAvatar!),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.6),
                                    backgroundImage: user!.photoUrl != null
                                        ? NetworkImage(user.photoUrl!)
                                        : null,
                                    child: user.photoUrl != null
                                        ? null
                                        : Text(
                                            Utils.nameInit(
                                                user.displayName ?? ""),
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue)),
                                  ),
                            SvgPicture.asset(
                              editIcon,
                              color: primaryColor,
                              width: 24,
                              height: 24,
                            )
                          ],
                        )),
                    const SizedBox(height: 5),
                    Text(
                      Utils.userName(
                        context.read<FirebaseAuthController>().appUser!.email ??
                            "",
                      ),
                      style: txtMedium(12),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Name",
                        style: txtSemiBold(18),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: newNameController,
                      style: txtMedium(18),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          hintText: "Name",
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              editIcon,
                              height: 24,
                              width: 24,
                            ),
                          ),
                          //prefixIcon: SizedBox(width: 24),
                          border: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: secondaryColor, width: 0.5))),
                    ),
                    const SizedBox(height: 42),
                    AuthButton(
                        title: "Update",
                        onTap: () async {
                          await context
                              .read<FirebaseAuthController>()
                              .updateUser(
                                  uid: user!.uid!,
                                  displayName: newNameController!.text,
                                  avatar: newAvatar)
                              .then((value) {
                            if (value) {
                              Navigator.pop(context);
                            }
                          });
                        })
                  ],
                ),
              ),
            ),
          ],
        ))),
        if (context.watch<FirebaseAuthController>().isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        // Mục đích của Stack chính là để khi nó đang loading thì
        // nó sẽ đè một cái Circular quay tròn lên trên màn hình update hiện tại
      ],
    );
  }
}
