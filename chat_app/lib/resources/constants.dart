import 'package:flutter/material.dart';

const Color primaryColor = Color(0xffE15B10);
// Màu chủ đạo cho App, cách lấy màu từ Figma: xoá # thay bằng 0xff
const Color secondaryColor = Color(0xffD6D6D6);
// Màu thứ hai, màu của các ô chat của người mình chat cùng

const String backIcon = "assets/icons/back.svg";
const String addIcon = "assets/icons/add.svg";
const String cameraIcon = "assets/icons/camera.svg";
const String closeIcon = "assets/icons/close.svg";
const String editIcon = "assets/icons/edit.svg";
const String fileIcon = "assets/icons/file.svg";
const String googleIcon = "assets/icons/google.svg";
const String imageIcon = "assets/icons/image.svg";
const String invisibleIcon = "assets/icons/invisible.svg";
const String optionIcon = "assets/icons/option.svg";
const String searchIcon = "assets/icons/search.svg";
const String sendIcon = "assets/icons/send.svg";
const String signOutIcon = "assets/icons/signout.svg";
const String videoIcon = "assets/icons/video.svg";
const String visibleIcon = "assets/icons/visible.svg";

const String amzChatIcon = "assets/images/amz_chat.png";
const String placeholderImage = "assets/images/image-placeholder.jpeg";

// Tạo sẵn các Text Style
// Với từng kiểu, sẽ nhận vào size và optinal color
TextStyle txtRegular(double size, [Color? color]) =>
    TextStyle(fontWeight: FontWeight.w400, fontSize: size, color: color);
TextStyle txtMedium(double size, [Color? color]) =>
    TextStyle(fontWeight: FontWeight.w500, fontSize: size, color: color);
TextStyle txtSemiBold(double size, [Color? color]) =>
    TextStyle(fontWeight: FontWeight.w600, fontSize: size, color: color);
TextStyle txtBold(double size, [Color? color]) =>
    TextStyle(fontWeight: FontWeight.w700, fontSize: size, color: color);
TextStyle txtExtraBold(double size, [Color? color]) =>
    TextStyle(fontWeight: FontWeight.w800, fontSize: size, color: color);
