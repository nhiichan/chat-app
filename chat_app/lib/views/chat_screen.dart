import 'package:chat_app/controllers/firebase_auth_controller.dart';
import 'package:chat_app/controllers/message_controller.dart';
import 'package:chat_app/data_sources/firebase_services.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/resources/constants.dart';
import 'package:chat_app/resources/widgets/chat/header_chat.dart';
import 'package:chat_app/resources/widgets/chat/input_message.dart';
import 'package:chat_app/resources/widgets/chat/message_item.dart';
import 'package:chat_app/resources/widgets/chat/option_item_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.receiver, this.chatRoomId})
      : super(key: key);
  final AppUser receiver;
  final String? chatRoomId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FireBaseServices fireBaseServices = FireBaseServices();
  final TextEditingController _messController = TextEditingController();
  bool isShowOption = false;
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthController>().appUser!;
    return ChangeNotifierProvider<MessageController>(
      create: (_) => MessageController(
          user: user, receiver: widget.receiver, chatRoomId: widget.chatRoomId),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: context.watch<MessageController>().isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      HeaderChat(receiver: widget.receiver),
                      context.watch<MessageController>().chatRoomId !=
                          null
                          ? StreamBuilder<
                          QuerySnapshot<Map<String, dynamic>>>(
                          stream: fireBaseServices.getStreamMessage(
                              context
                                  .watch<MessageController>()
                                  .chatRoomId!),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            List<Message> listMessage = snapshot
                                .data!.docs
                                .map<Message>(
                                    (e) => Message.fromJson(e.data()))
                                .toList();
                            return Expanded(
                                child: ListView.builder(
                                  cacheExtent: 1000,
                                  padding: const EdgeInsets.only(bottom: 24),
                                  itemCount: listMessage.length,
                                  reverse: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final isMe = user.uid ==
                                        listMessage[index].senderId;
                                    bool isMidle = false;
                                    bool isLast = false;
                                    if (index != 0 &&
                                        index < listMessage.length - 1) {
                                      isMidle = listMessage[index]
                                          .senderId ==
                                          listMessage[index - 1]
                                              .senderId &&
                                          listMessage[index].senderId ==
                                              listMessage[index + 1]
                                                  .senderId;
                                      isLast = listMessage[index]
                                          .senderId ==
                                          listMessage[index - 1]
                                              .senderId &&
                                          listMessage[index].senderId !=
                                              listMessage[index + 1]
                                                  .senderId;
                                    }
                                    return MessageItem(
                                      message: listMessage[index],
                                      isMe: isMe,
                                      isMidle: isMidle,
                                      isLast: isLast,
                                    );
                                  },
                                ));
                          })
                          : Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 56),
                              child: Text(
                                "Hãy gửi lời chào tới người bạn mới!",
                                style: txtMedium(24),
                              ),
                            ),
                          )),
                      InputMessage(
                        controller: _messController,
                        iconOption: isShowOption ? closeIcon : addIcon,
                        onTapOption: () {
                          setState(() {
                            isShowOption = !isShowOption;
                          });
                        },
                      )
                    ],
                  ),
                  OptionItemMessage(
                    onTap: () async {
                      await context
                          .read<MessageController>()
                          .onPickCamera();
                    },
                    duration: const Duration(milliseconds: 1000),
                    color: const Color(0xff0066ff),
                    icon: cameraIcon,
                    isShow: isShowOption,
                    showPositionBottom: 72,
                    showPositionLeft: 16,
                  ),
                  OptionItemMessage(
                    onTap: () async {
                      await context
                          .read<MessageController>()
                          .mediaPicker(context, RequestType.image);
                    },
                    duration: const Duration(milliseconds: 900),
                    color: const Color(0xff4F2BFF),
                    icon: imageIcon,
                    isShow: isShowOption,
                    showPositionBottom: 72,
                    showPositionLeft: 16 * 2 + 38,
                  ),
                  OptionItemMessage(
                    onTap: () async {
                      await context
                          .read<MessageController>()
                          .mediaPicker(context, RequestType.video);
                    },
                    duration: const Duration(milliseconds: 800),
                    color: const Color(0xff38963C),
                    icon: videoIcon,
                    isShow: isShowOption,
                    showPositionBottom: 72,
                    showPositionLeft: 16 * 3 + 38 * 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}