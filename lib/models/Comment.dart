import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String name, uid, commentid, postid, text,usrimg;
  Timestamp date;

  Comment(
      {required this.name,
      required this.text,
      required this.commentid,
      required this.uid,
      required this.date,
        required this.usrimg,
      required this.postid,});
  factory Comment.fromJson(dynamic maap) {
    return Comment(
        commentid : maap['Comment ID'],
        date : maap["Time"],
        uid : maap['User ID'],
        text : maap["Text"],
        postid : maap["Post ID"],
        usrimg : maap["Usr Image"],
        name : maap["Full Name"]);
  }
}
