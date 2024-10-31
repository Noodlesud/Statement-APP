import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teyake/pages/comment.dart';
import 'package:teyake/pages/question_model.dart';
import 'package:teyake/pages/save.dart';
import 'package:teyake/pages/signup.dart';
import 'package:teyake/pages/user.dart';

class Repo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Map<String, dynamic> retrievedData = SaveData.retrieveUserData();

  @override
  void onReady() {}

  Future<List<QuestionModel>> getAllquestion() async {
    try {
      final snapshot = await _db.collection("questions").get();

      final productsData =
          snapshot.docs.map((e) => QuestionModel.fromSnapshot(e)).toList();

      return productsData;
    } catch (error) {
      print("Error fetching questions: $error");
      rethrow;
    }
  }

  Future<List<CommentModel>> getcomment(String questionid) async {
    try {
      final snapshot = await _db
          .collection("comment")
          .where("Question-ID", isEqualTo: questionid)
          .get();

      final commentData =
          snapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList();

      return commentData;
    } catch (error) {
      print("Error fetching questions: $error");
      rethrow;
    }
  }

  Future<bool> userExistsByEmailOrPhone(String email, String phone) async {
    try {
      final phonesnapshot =
          await _db.collection("Users").where("Email", isEqualTo: email).get();

      final emailsnapshot =
          await _db.collection("Users").where("Phone", isEqualTo: phone).get();

      // Check if email exists in either collection
      return phonesnapshot.docs.isNotEmpty || emailsnapshot.docs.isNotEmpty;
    } catch (error) {
      print("Error while checking user existence by email: $error");
      return false;
    }
  }

  Future<bool> userExistsByEmailandPassword(
      String email, String password) async {
    try {
      final accountsnapshot = await _db
          .collection("Users")
          .where("Password", isEqualTo: password)
          .where("Email", isEqualTo: email)
          .get();

      // Check if email exists in either collection
      return accountsnapshot.docs.isNotEmpty;
    } catch (error) {
      print("Error while checking user existence by email: $error");
      return false;
    }
  }

  Future<List<UserModel>> data(String email, String password) async {
    try {
      final accountsnapshot = await _db
          .collection("Users")
          .where("Password", isEqualTo: password)
          .where("Email", isEqualTo: email)
          .get();

      // Check if email exists in either collection
      final userData =
          accountsnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();

      if (userData.isNotEmpty) {
        final firstUser = userData[0];
        SaveData.storeUserData({
          'Name': firstUser.name,
          'Phone': firstUser.phone,
          'Password': firstUser.password,
          'Email': firstUser.email,
          'User-ID': firstUser.userid,
          'ImageURL': firstUser.imageurl
        });
      }

      return userData;
    } catch (error) {
      print("Error fetching questions: $error");
      rethrow;
    }
  }

  Future<void> delete(String? id) async {
    final querySnapshot = await _db.collection('comment').doc(id).delete();
  }

  Future<void> deleteEntry(String? id) async {
    final querySnapshot = await _db.collection('questions').doc(id).delete();
  }

  Future<void> logout(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUp()),
    );
  }
}
