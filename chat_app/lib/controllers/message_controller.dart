import 'dart:io';
import 'dart:typed_data';

import 'package:chat_app/data_sources/firebase_services.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/room_chat.dart';
import 'package:chat_app/resources/widgets/chat/bottom_sheet_media.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

class MessageController with ChangeNotifier {
  final FireBaseServices fireBaseServices = FireBaseServices();
  final AppUser? user;
  final AppUser? receiver;
  // Cứ hình dung Controller được sử dụng trong một Room chat đi
  // Thì nó sẽ cần biết room đấy đang trao đổi giữa ai và ai
  String? chatRoomId;
  bool isLoading = true;

  List<Message> messageList = [];
  List<File> fileList = [];
  List<AssetEntity> mediaList = [];
  List<Uint8List> mediaData = [];

  ///***** HÀM KHỞI TẠO *****///
  MessageController(
      {required this.user, required this.receiver, required this.chatRoomId}) {
    _init();
  }

  void getRoomChatId() async {
    if (chatRoomId == null && receiver != null) {
      chatRoomId =
          await fireBaseServices.getIdRoomChat(user!.uid!, receiver!.uid!);
    }
  }

  void _init() async {
    // Giả sử hai người chưa chat với nhau bao giờ
    // thì mình sẽ phải tạo ra một cái room chat mới, tạo id ở fireStore
    getRoomChatId();
    _unLoading();
  }

  ///***** CẬP NHẬT LOADING *****///
  _loading() {
    isLoading = true;
    notifyListeners();
  }

  _unLoading() {
    isLoading = false;
    notifyListeners();
  }

  ///***** GỬI MESSAGE *****///
  void onSend({required String message}) async {
    final roomId = chatRoomId ?? const Uuid().v4();
    // Create a version 4 (random) UUID
    _loading();
    await fireBaseServices.sendMessage(
        roomChat: RoomChat(
          id: roomId,
          membersId: [user!.uid!, receiver!.uid!],
          message: message,
          senderId: user!.uid,
        ),
        message: Message(
            id: const Uuid().v4(),
            roomChatId: roomId,
            message: message,
            senderId: user!.uid,
            senderName: user!.displayName,
            type: "message"));
    // Cứ mỗi lần nhắn là nó lại lắng nghe rồi update liên tục
    getRoomChatId();
    _unLoading();
  }

  ///***** GỬI MEDIA *****///
  Future onSendMedia(List<int> indexs, String type) async {
    final roomId = chatRoomId ?? const Uuid().v4();
    final messageId = const Uuid().v4();
    List<String> medias = [];

    for (int i = 0; i < indexs.length; i++) {
      medias.add("");
    }

    _loading();
    await fireBaseServices.sendMessage(
        roomChat: RoomChat(
          id: roomId,
          membersId: [user!.uid!, receiver!.uid!],
          message:
              type == "image" ? "Image" : "Video", // Chỉ gửi video hoặc ảnh
          senderId: user!.uid,
        ),
        message: Message(
            id: const Uuid().v4(),
            roomChatId: roomId,
            medias: medias,
            message: "",
            senderId: user!.uid,
            senderName: user!.displayName,
            type: type));

    for (int i = 0; i < indexs.length; i++) {
      // Update send từng file một
      final file = await mediaList[indexs[i]].file;
      String? fileUrl =
          await fireBaseServices.uploadFileMessage(user!.uid!, file!);

      if (fileUrl != null) {
        medias[i] = fileUrl;
        await fireBaseServices.updateMessageMedias(medias, roomId, messageId);
      }

      getRoomChatId();
    }

    mediaList.clear();
    mediaData.clear();

    _unLoading();
  }

  ///***** CHỌN ICON CAMERA (CHỤP ẢNH) *****///
  Future onPickCamera() async {
    var ans = await PhotoManager.requestPermissionExtend();
    if (ans.isAuth) {
      // Nếu đã được cấp quyền
      ImagePicker imagePicker = ImagePicker();

      final xFile = await imagePicker.pickImage(source: ImageSource.camera);
      // File sẽ lấy từ camera sau khi chụp

      if (xFile != null) {
        final roomId = chatRoomId ?? const Uuid().v4();
        final messageId = const Uuid().v4();

        _loading();
        await fireBaseServices.sendMessage(
            roomChat: RoomChat(
              id: roomId,
              membersId: [user!.uid!, receiver!.uid!],
              message: "Image",
              senderId: user!.uid,
            ),
            message: Message(
                id: messageId,
                roomChatId: roomId,
                medias: [""],
                message: "",
                senderId: user!.uid,
                senderName: user!.displayName,
                type: "image"));

        final file = File(xFile.path);
        String? imageUrl =
            await fireBaseServices.uploadFileMessage(user!.uid!, file);
        if (imageUrl != null) {
          await fireBaseServices
              .updateMessageMedias([imageUrl], roomId, messageId);
        }

        getRoomChatId();
        _unLoading();
      }
    }
  }

  ///***** CHỌN CÁC FILE MEDIA ĐỂ TẢI LÊN *****///
  Future mediaPicker(BuildContext buildContext, RequestType requestType) async {
    var ans = await PhotoManager.requestPermissionExtend();
    if (ans.isAuth) {
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList(
        type: requestType,
        hasAll: true,
        onlyAll: true,
      );
      mediaList = await list[0].getAssetListRange(start: 0, end: 100);

      for (var media in mediaList) {
        final data = await media.thumbDataWithSize(300, 300);
        mediaData.add(data!);
      }
      notifyListeners();
      await showModalBottomSheet<List<int>>(
        enableDrag: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: buildContext,
        builder: (context) => BottomSheetMedia(mediaData: mediaData),
        // Là một Widget để hiện ở phía dưới đáy màn hình (bottom)
      ).then((value) {
        if (value != null) {
          if (requestType == RequestType.image) {
            onSendMedia(value, "image");
          } else {
            onSendMedia(value, "video");
          }
        } else {
          mediaList.clear();
          mediaData.clear();
        }
      });
    } else {
      PhotoManager.openSetting();
    }
  }
}
