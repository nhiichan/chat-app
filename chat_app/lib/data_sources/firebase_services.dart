// ignore_for_file: avoid_print

import 'dart:io';

import 'package:chat_app/data_sources/firebase_repository.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/room_chat.dart';
import 'package:chat_app/resources/strings.dart';
import 'package:chat_app/resources/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

class FireBaseServices {
  final FirebaseRepository firebaseRepository = FirebaseRepository();
  // Tạo một instance mới của firebaseRepository
  // Chứa các hàm, phương tức để tương tác với api

  // Cái này là mình cần tự tạo các model
  // của mình sau khi đã có các phương thức ở trên api

  ///***** PHẦN ĐĂNG KÝ *****///
  Future createAccountWithEmailAndPassword(
      {required String email,
      required String password,
      required String name,
      File? avatar, // khai báo thư viện dart:io
      Function(AppUser)? onDone,
      Function? onError}) async {
    // Hàm tạo tài khoản với email và password
    // Với tên hiển thị là name và avatar

    // Vì sẽ mất thời gian để đẩy thông tin account lên cơ sở dữ liệu
    // nên cần xử lý bất đồng bộ async await

    try {
      await firebaseRepository.firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        // chạy xong nó sẽ trả về value, và việc của mình là xử lý value đấy
        if (value.user != null) {
          String? photoUrl;
          if (avatar != null) {
            photoUrl = await uploadFile(value.user!.uid, avatar);
          }
          final AppUser appUser = AppUser(
              uid: value.user!.uid,
              displayName: name,
              email: value.user!.email,
              photoUrl: photoUrl);

          await createUserToDatabase(appUser).then((value) => onDone!(appUser));
          // Nếu đẩy lên thành công thì function onDone sẽ được chạy với giá trị của appUser.
        }
      });
      Utils.showToast(SUCCESS_REGISTER, 1);
    } on FirebaseAuthException catch (e) {
      onError!(); // OnError sẽ được chạy
      if (e.code == 'weak-password') {
        Utils.showToast(WEAK_PASSWORD, 0);
      } else if (e.code == 'email-already-in-use') {
        Utils.showToast(EMAIL_ALREADY_IN_USE, 0);
      } else {
        Utils.showToast(e.message ?? "", 0);
      }
    }
  }

  Future createUserToDatabase(AppUser appUser) async {
    // Vì mất thời gian nên dữ liệu là Future<dynamic> và
    // cần xử lý bất đồng bộ async await
    await firebaseRepository.firebaseFirestore
        .collection("users") // Tạo ra một collection tên là users
        .doc(appUser.uid) // Lưu trữ theo trường id
        .set(appUser.toJson());
    // Mỗi một id sẽ chứa một dict là dạng json thông tin user
  }

  Future<String?> uploadFile(String? userId, File? file) async {
    // required mới cần đóng mở ngoặc nhọn!

    // Lấy id, file và thực hiện thao tác đẩy ảnh lên

    String fileName = const Uuid().v4();
    try {
      final uploadTask = await firebaseRepository.firebaseStorage
          .ref('user/$userId/$fileName.jpg')
          .putFile(file!); // Lưu trữ theo đường dẫn này
      return uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      // Nếu vào đúng lỗi FirebaseException thì sẽ không vào catch nữa
      Utils.showToast(e.message ?? "", 0);
    }
  }

  ///***** PHẦN ĐĂNG NHẬP *****///
  Future signInWithEmailAndPassword({required email, required password}) async {
    try {
      await firebaseRepository.firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      Utils.showToast(SUCCESS_LOGIN, 1);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.showToast(USER_NOT_FOUND, 0);
      } else if (e.code == 'wrong-password') {
        Utils.showToast(WRONG_PASSWORD, 0);
      } else {
        Utils.showToast(e.message ?? "", 0);
      }
    }
  }

  Future signInWithGoogle() async {
    UserCredential? user;
    try {
      GoogleSignInAccount? _googleSignInAccount =
          await firebaseRepository.googleSignIn.signIn(); // private
      if (_googleSignInAccount != null) {
        GoogleSignInAuthentication _googleSignInAuthentication =
            await _googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: _googleSignInAuthentication.accessToken,
            idToken: _googleSignInAuthentication.idToken);

        user = await firebaseRepository.firebaseAuth
            .signInWithCredential(authCredential);

        if (user.user != null) {
          final AppUser appUser = AppUser(
              uid: user.user!.uid,
              displayName: user.user!.displayName,
              email: user.user!.email,
              photoUrl: user.user!.photoURL);
          await createUserToDatabase(appUser);
        }
      }
    } on FirebaseAuthException catch (e) {
      Utils.showToast(e.message ?? "", 0);
    }
  }

  ///***** PHẦN ĐĂNG XUẤT *****///
  Future signOut() async {
    // Bất kể đăng nhập bằng phương thức nào cũng signOut được bằng cái này!
    firebaseRepository.firebaseAuth.signOut();
    return firebaseRepository.firebaseAuth.signOut();
  }

  ///***** LẤY THÔNG TIN NGƯỜI DÙNG *****///
  Future<AppUser?> getUser(String uid) async {
    // Lấy thông tin người dùng qua uid
    final snapshot = await firebaseRepository.firebaseFirestore
        .collection("users") // truy cập vào collection users
        .doc(uid) // lấy qua uid
        .get();
    if (snapshot.exists) {
      return AppUser.fromJson(snapshot.data()!);
    }
  }

  Stream<User?> userChangeStream() async* {
    // Tạo ra một cái stream lấy dữ liệu người dùng
    // khi mà thông tin người dùng thay đổi
    yield* firebaseRepository.firebaseAuth.userChanges();
  }

  ///***** GỬI MESSAGE *****///
  Future sendMessage(
      {required RoomChat roomChat, required Message message}) async {
    // Gửi thông tin tin nhắn mới lên fireStore
    await firebaseRepository.firebaseFirestore
        .collection("chats") // đầu tiên tìm collection tên chats
        .doc(roomChat.id) // vào theo id của roomChat
        .collection("messages") // bên trong roomChat chứa collection messages
        .doc(message.id) // truy cập vào theo id của message
        .set(message.toJson()); // up lên dạng json

    // Gửi thông tin về roomChat lên fireStore
    await firebaseRepository.firebaseFirestore
        .collection("chats")
        .doc(roomChat.id)
        .set(roomChat.toJson());
  }

  ///***** LẤY TOÀN BỘ MESSAGE VỀ *****///
  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamMessage(
      String roomChatId) async* {
    // Khi lấy về thì dữ liệu sẽ là dạng stream -> async*
    // snapshot đại diện cho một kiểu dữ liệu
    yield* firebaseRepository.firebaseFirestore
        .collection("chats")
        .doc(roomChatId)
        .collection("messages") // vào collection messages của một room chat
        .orderBy("time_stamp", descending: true)
        // sort theo time_stamp của message theo chiều giảm dần
        .snapshots();
  }

  ///***** LẤY ID PHÒNG CHAT (từ id người gửi và nhận) *****///
  Future<String?> getIdRoomChat(String senderId, String receiverId) async {
    final snapshot =
        await firebaseRepository.firebaseFirestore.collection("chats").get();
    // Tìm kiếm phòng chat có sự tham gia của sender và receiver
    for (var doc in snapshot.docs) {
      // Duyệt qua mọi phần tử trong collection chats thông qua doc
      List<dynamic> membersId = doc.get("members_id");
      if (membersId.any((element) => element == senderId) &&
          // Cái này như kiểu nó xét từng phẩn tử trong List rồi thực hiện thao tác so sánh
          // Nếu tồn tại (if any) thoả mãn => true không tồn tại thì false
          membersId.any((element) => element == receiverId)) {
        return doc.get("id");
      }
    }
  }

  ///***** UPLOAD MESSAGE DẠNG FILE *****///
  Future<String?> uploadFileMessage(String? userId, File? file) async {
    String fileName = const Uuid().v4();
    try {
      final uploadTask = await firebaseRepository.firebaseStorage
          // riêng cái này lưu trong firebaseStorage
          .ref('message/$userId/$fileName')
          // mình không rõ kiểu file nhưng sẽ lưu trong message chứ không phải user
          .putFile(file!); // Lưu trữ theo đường dẫn này
      return uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      Utils.showToast(e.message ?? "", 0);
    }
  }

  ///***** UPDATE CÁC FILE MEDIA *****///
  Future updateMessageMedias(
      List<String> medias, String roomChatId, String messageId) async {
    await firebaseRepository.firebaseFirestore
        .collection("chats")
        .doc(roomChatId)
        .collection("messages")
        .doc(messageId)
        .update({"medias": medias});
  }

  ///***** LẤY TOÀN BỘ NGƯỜI DÙNG VỀ *****///
  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamUser(
      String uid) async* {
    yield* firebaseRepository.firebaseFirestore
        .collection("users")
        .doc(uid)
        .snapshots();
  }

  ///***** LẤY TOÀN BỘ ROOMCHAT THEO SENDERID *****///
  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamRoomChat(
      String userId) async* {
    // Lấy về tất cả roomChat của một user nào đó
    yield* firebaseRepository.firebaseFirestore
        .collection("chats")
        .where("mebers_id", arrayContains: userId)
        .snapshots();
  }

  ///***** TÌM KIẾM USER *****///
  Future<List<AppUser>> searchUser(String uid) async {
    List<AppUser> ans = [];
    final snapshot =
        await firebaseRepository.firebaseFirestore.collection("users").get();
    for (var doc in snapshot.docs) {
      if (doc.id != uid) {
        print(doc.data());
        ans.add(AppUser.fromJson(doc.data()));
      }
    }
    // Trả về List chứa toàn bộ các user có uid khác uid cần tìm
    return ans;
  }

  ///***** THAY ĐỔI THÔNG TIN NGƯỜI DÙNG *****///
  Future updateUser(
      {required String userId,
      required String displayName,
      File? avatar}) async {
    // có thể thay đổi displayName và avatar, nếu không đổi displayName thì
    // truyền vào displayName cũ.

    if (avatar != null) {
      String? photoUrl = await uploadFile(userId, avatar);
      await firebaseRepository.firebaseFirestore
          .collection("users")
          .doc(userId)
          .update({"photo_url": photoUrl});
      // Hàm Update tham số truyền vào là dạng Map<String, Object?> data
    }
    await firebaseRepository.firebaseFirestore
        .collection("users")
        .doc(userId)
        .update({"display_name": displayName});
  }
}
