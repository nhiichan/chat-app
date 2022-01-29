import 'package:chat_app/data_sources/firebase_services.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:flutter/material.dart';

class SearchController with ChangeNotifier {
  List<AppUser> _listAllUser = [];
  List<AppUser> _listSearchUser = [];
  List<AppUser> get listSearchUser => _listSearchUser;
  List<AppUser> get listAllUser => _listAllUser;
  // getter;

  FireBaseServices fireBaseServices = FireBaseServices();

  ///***** HÀM KHỞI TẠO *****///
  SearchController(String uid) {
    _init(uid);
  }

  _init(String uid) async {
    _listAllUser = await fireBaseServices.searchUser(uid);
    notifyListeners();
  }

  ///***** HÀM TÌM KIẾM USER THEO TEXT *****///
  searchUser(String text) {
    List<AppUser> list = [];
    if (text.isNotEmpty) {
      for (var element in _listAllUser) {
        final displayName = element.displayName!.toLowerCase();
        final email = element.email!.toLowerCase();
        final key = text.toLowerCase();
        // Mình sẽ tìm kiếm theo tên của người dùng hoặc theo email mà người đó
        // đã dùng để đăng ký
        if (displayName.contains(key) || email.contains(key)) {
          list.add(element);
        }
      }
      _listSearchUser = list; // Với mỗi phần tử thì lại làm gì đó
    } else {
      _listSearchUser = [];
    }
    notifyListeners();
  }

  ///***** HÀM XOÁ CÁC LỰA CHỌN TÌM KIẾM */
  clearSearch() {
    _listSearchUser.clear();
    notifyListeners();
  }
}
