import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String comment;
  final String questionid;
  final String userid;
  final String name;
  CommentModel(
      {required this.id,
      required this.comment,
      required this.questionid,
      required this.userid,
      required this.name});
  toJson() {
    return {
      "Question": comment,
      "Question-ID": questionid,
      "user-ID": userid,
      "Name": name
    };
  }

  factory CommentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CommentModel(
        id: document.id,
        comment: data["Comment"],
        questionid: data["Question-ID"],
        userid: data["User-ID"],
        name: data["Name"]);
  }
}
