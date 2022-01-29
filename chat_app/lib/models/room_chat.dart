// Class đại diện cho Một phòng chat 2 người
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomChat {
  // trên FireStore thì nó sẽ lưu ở dạng String
  String? id; // id của cái RoomChat đấy (để sau còn lưu lên firebase)
  List<String>? membersId;
  // id của những người tham gia RoomChat (có thể là gr chat nhiều người)
  String? message; // tin nhắn
  String? senderId; // người đang chat
  Timestamp? timeStamp; // dấu mốc thời gian

  RoomChat(
      {this.id, this.membersId, this.message, this.senderId, this.timeStamp});

  RoomChat.fromJson(Map<String, dynamic> json) {
    // Hàm chuyển dữ liệu từ json vào 1 room chat
    id = json["id"];
    membersId = json["members_id"] == null
        ? null
        : List<String>.from(json["members_id"]);
    message = json["message"];
    senderId = json["sender_id"];
    timeStamp = json["time_stamp"];
  }

  Map<String, dynamic> toJson() {
    // Hàm chuyển dữ liệu 1 instance thành dạng json để up lên firebase
    Map<String, dynamic> json = {};
    json["id"] = id;
    if (membersId != null) json["members_id"] = membersId;
    json["message"] = message;
    json["sender_id"] = senderId;
    json["time_stamp"] = FieldValue.serverTimestamp();
    // Returns a sentinel used with set() or update()
    // to include a server-generated timestamp in the written data.
    return json;
  }
}
