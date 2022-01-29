import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/resources/utils/utils.dart';
import 'package:chat_app/views/chat_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class SearchResultUserItem extends StatelessWidget {
  const SearchResultUserItem({
    Key? key,
    required this.appUser,
  }) : super(key: key);

  final AppUser appUser;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.withOpacity(0.6),
        radius: 23,
        backgroundImage:
        appUser.photoUrl != null ? NetworkImage(appUser.photoUrl!) : null,
        child: appUser.photoUrl != null
            ? null
            : Text(Utils.nameInit(appUser.displayName ?? ""),
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.blue)),
      ),
      title: Text(
        appUser.displayName ?? "",
        style: txtMedium(18),
      ),
      subtitle: Text(
        Utils.userName(appUser.email ?? ""),
        style: txtRegular(14),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatScreen(receiver: appUser)));
      },
    );
  }
}