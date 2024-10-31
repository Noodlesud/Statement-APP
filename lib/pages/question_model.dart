import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  final String id;
  final String question;
  final String userid;
  final String questionid;
  String like;
  QuestionModel(
      {required this.id,
      required this.question,
      required this.questionid,
      required this.userid,
      required this.like});
  toJson() {
    return {
      "Question": question,
      "Question-ID": questionid,
      "User-ID": userid,
      "Like": like
    };
  }

  factory QuestionModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return QuestionModel(
        id: document.id,
        question: data["Question"],
        userid: data["User-ID"],
        questionid: data["Question-ID"],
        like: data["Like"]);
  }
}
