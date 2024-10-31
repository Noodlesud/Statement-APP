import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String password;
  final String userid;
  final String imageurl;

  UserModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.password,
      required this.userid,
      required this.imageurl});
  toJson() {
    return {
      "Name": name,
      "Phone": phone,
      "Email": email,
      "Password": password,
      "User-ID": userid,
      "ImageURL": imageurl
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        name: data["Name"],
        password: data["Password"],
        phone: data["Phone"],
        email: data["Email"],
        userid: data["User-ID"],
        imageurl: data["ImageURL"]);
  }
}
