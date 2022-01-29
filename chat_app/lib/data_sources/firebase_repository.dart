  // Class này chứa các hàm, các phương thức để có thể tương tác với Api 
  // Tức là các hàm, phương thức có sẵn ở trong Api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseRepository {  
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // Bản chất là có dữ liệu rồi
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  // Chứa ảnh các thứ
  GoogleSignIn googleSignIn = GoogleSignIn();
}
