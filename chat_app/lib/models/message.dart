// Class đại diện cho Message
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id; // id của cái message đấy
  // nói chung là model muốn lưu lên được firebase thì đều cần id riêng
  String? roomChatId; // Id của phòng chat chứa message
  String? message; // Nội dung message
  String? senderId; // id người gửi
  String? senderName; // tên người gửi
  Timestamp? timeStamp; // mốc thời gian để sắp xếp và hiện
  List<String>? medias; // Chứa các đường dẫn ảnh, video, file đã gừi
  String? type; // Thể loại: text, ảnh,...

  Message(
      {this.id,
      this.roomChatId,
      this.message,
      this.senderId,
      this.senderName,
      this.timeStamp,
      this.medias,
      this.type});

  Message.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    roomChatId = json["room_chat_id"];
    message = json["message"];
    senderId = json["sender_id"];
    senderName = json["sender_name"];
    timeStamp = json["time_stamp"];
    medias = json["medias"] == null ? null : List<String>.from(json["medias"]);
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["room_chat_id"] = roomChatId;
    json["message"] = message;
    json["sender_id"] = senderId;
    json["sender_name"] = senderName;
    json["time_stamp"] = FieldValue.serverTimestamp();
    medias = json["medias"] == null ? null : List<String>.from(json["medias"]);
    json["type"] = type;
    return json;
  }
}
