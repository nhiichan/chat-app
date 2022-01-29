import 'dart:async';
import 'dart:io';

import 'package:chat_app/data_sources/firebase_services.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/resources/strings.dart';
import 'package:chat_app/resources/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// Bản chất giống như list các case (các trạng thái)
enum AuthStatus {
  none,
  authenticate,
  unauthenticate
  // none, xác thực, chưa xác thực
}

class FirebaseAuthController with ChangeNotifier {
  // with giống extends
  AuthStatus authStatus = AuthStatus.none;

  // Giờ mình sẽ tạo ra các hàm để liên tục thay đổi cái authStatus này
  // Để rồi truyền xuống các view rồi hiển thị các widget

  // Sử dụng hai phương tiện
  final FireBaseServices _fireBaseServices = FireBaseServices();
  late StreamSubscription _authStreamSubscription;
  // Lưu giữ lại để biết dữ liệu trong Stream liên tục là gì thì App sẽ thay đổi theo

  AppUser? appUser;
  bool isLoading = false;

  ///***** HÀM KHỞI TẠO *****///
  FirebaseAuthController() {
    _init();
  }

  void _init() {
    _authStreamSubscription =
        _fireBaseServices.userChangeStream().listen((user) async {
      // Đầu tiên là lắng nghe lấy dữ liệu về user từ App
      if (user != null) {
        // Đã đăng nhập rồi đó!
        await _fireBaseServices.getUser(user.uid).then((value) async {
          // Lấy dữ liệu về user xem có tồn tại hay không
          if (value != null) {
            appUser = value;
            authStatus = AuthStatus.authenticate;
            // Đã được xác thực!!!
          }
        });
      } else {
        appUser = null;
        authStatus = AuthStatus.unauthenticate;
        // Chưa được xác thực!!!
        // Như này thì View lập tức sẽ thay đổi.
        // Ví dụ như hiển thị phải đăng nhập lại
      }
      notifyListeners();
    });
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

  ///***** ĐĂNG NHẬP ******///
  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    _loading(); // Cập nhật tình trạng là đang loading
    await _fireBaseServices.signInWithEmailAndPassword(
        email: email, password: password);
    _unLoading();
  }

  Future signInWithGoogle() async {
    _loading();
    await _fireBaseServices.signInWithGoogle();
    _unLoading();
  }

  ///***** TẠO TÀI KHOẢN MỚI *****///
  Future<bool?> createAccount(
      {required String name,
      required String email,
      required String password,
      File? file}) async {
    bool created = false;
    _loading();
    await _fireBaseServices.createAccountWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        avatar: file,
        onDone: (user) {
          created = true;
          _unLoading();
          appUser = user;
        },
        onError: () {
          created = false;
        });
    return created;
  }

  ///***** ĐĂNG XUẤT *****///
  Future signOut() async {
    _loading();
    await _fireBaseServices.signOut();
    _unLoading();
  }

  ///***** UPDATE THÔNG TIN USER *****///
  Future<bool> updateUser(
      {required String uid, required String displayName, File? avatar}) async {
    _loading();
    try {
      await _fireBaseServices.updateUser(
          userId: appUser!.uid!,
          displayName:
              displayName.isEmpty ? appUser!.displayName! : displayName,
          avatar: avatar);
      appUser = await _fireBaseServices.getUser(appUser!.uid!);
      Utils.showToast(SUCCESS_UPDATE_PROFILE, 1);
      _unLoading();
      return true;
    } on FirebaseException catch (e) {
      Utils.showToast(e.message ?? "", 0);
      _unLoading();
      return false;
    }
  }
}
