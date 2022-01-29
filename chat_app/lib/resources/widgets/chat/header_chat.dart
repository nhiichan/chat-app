import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/resources/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';

class HeaderChat extends StatelessWidget {
  const HeaderChat({Key? key, required this.receiver})
      : super(key: key);

  final AppUser receiver;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(backIcon,
                width: 30, height: 30, color: primaryColor),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.withOpacity(0.6),
            backgroundImage: receiver.photoUrl != null
                ? NetworkImage(receiver.photoUrl!)
                : null,
            child: receiver.photoUrl != null
                ? null
                : Text(Utils.nameInit(receiver.displayName ?? ""),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor)),
          ),
          const SizedBox(width: 16),
          Text(
            receiver.displayName ?? "",
            style: txtSemiBold(18),
          )
        ],
      ),
    );
  }
}