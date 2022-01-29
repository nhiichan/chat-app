import 'package:chat_app/controllers/firebase_auth_controller.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/resources/constants.dart';
import 'package:chat_app/resources/utils/utils.dart';
import 'package:chat_app/views/change_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HeaderHome extends StatelessWidget {
  final AppUser user;
  const HeaderHome({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          amzChatIcon,
          width: 34,
          height: 34,
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: secondaryColor,
          backgroundImage:
              user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
          child: user.photoUrl != null
              ? null
              : Text(Utils.nameInit(user.displayName ?? ""),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor)),
        ),
        PopupMenuButton<int>(
          offset: const Offset(0, 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onSelected: (val) {
            if (val == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChangeProfileScreen()));
            } else {
              context.read<FirebaseAuthController>().signOut();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 0, // giá trị này sẽ được dùng để 
                // kết nối với hàm onSelected phía trên
                child: ListTile(
                  leading: SvgPicture.asset(
                    editIcon,
                    height: 30,
                    width: 30,
                  ),
                  title: const Text("Chỉnh sửa thông tin"),
                )),
            PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: SvgPicture.asset(
                    signOutIcon,
                    height: 30,
                    width: 30,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                )),
          ],
          child: SvgPicture.asset(
            optionIcon,
            height: 30,
            width: 30,
            color: primaryColor,
          ),
        )
      ],
    );
  }
}
