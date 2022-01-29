import 'package:chat_app/data_sources/firebase_services.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/models/room_chat.dart';
import 'package:chat_app/views/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import 'item_room_chat.dart';
class BodyHome extends StatelessWidget {
  final FireBaseServices fireBaseServices;
  final AppUser user;

  const BodyHome({
    Key? key,
    required FireBaseServices fireBaseServices,
    required this.user
  })  : fireBaseServices = fireBaseServices,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: fireBaseServices.getStreamRoomChat(user.uid!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isNotEmpty) {
            List<RoomChat> listRoomChat = [];
            for (var doc in snapshot.data!.docs) {
              final roomChat = RoomChat.fromJson(doc.data());
              listRoomChat.add(roomChat);
            }
            listRoomChat.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));

            return ListView.builder(
              padding: const EdgeInsets.only(top: 30),
              itemCount: listRoomChat.length,
              itemBuilder: (context, index) => ItemRoomChat(
                userId: user.uid!,
                fireBaseService: fireBaseServices,
                roomChat: listRoomChat[index],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 56),
                    child: Text(
                      "Bạn chưa có tin nhắn nào",
                      textAlign: TextAlign.center,
                      style: txtMedium(25),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                      onPressed: () {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SearchScreen()));


                      },
                      icon: SvgPicture.asset(searchIcon,
                          width: 24, height: 24, color: primaryColor),
                      label: Text(
                        "Hãy tìm kiếm bạn bè!",
                        style: txtMedium(23, primaryColor),
                      ))
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}