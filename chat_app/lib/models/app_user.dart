// Chứa class đại diện cho người dùng ứng dụng

class AppUser {
  String? uid; // user id
  String? displayName; // tên hiển thị
  String? email; // email
  String? photoUrl; // avatar

  AppUser(
      {required this.uid,
      required this.displayName,
      required this.email,
      required this.photoUrl});
  
  // Phương thức lấy dữ liệu người dùng dạng Json từ cơ sở dữ liệu 
  // về dạng AppUser
  // Đây cũng là một phương thức thuộc class chứ không thuộc instance
  AppUser.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    displayName = json["display_name"];
    email = json["email"];
    photoUrl = json["photo_url"];
  }

  // Phương thức để đẩy thông tin của App User
  // thành json để có thể đẩy lên cơ sở dữ liệu
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["uid"] = uid;
    data["display_name"] = displayName; 
    // tên của các trường trong file json thì sẽ cách nhau bởi _ 
    // chứ không viết liền
    data["email"] = email;
    data["photo_url"] = photoUrl;
    return data;
  }
}
