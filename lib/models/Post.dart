import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String name, uid, postid, text,usrimg;
  Timestamp date;
  int like, comment, bgnumber;
  List<dynamic> Imageurls = [];

  Post(
      {required this.name,
      required this.bgnumber,
      required this.text,
      required this.postid,
      required this.uid,
        required this.usrimg,
      required this.date,
      required this.comment,
      required this.Imageurls,
      required this.like});
  factory Post.fromJson(dynamic maap) {
    return Post(like : maap["Like"],
        Imageurls : maap["Images"],
        comment : maap['Comment'],
        date : maap["Time"],
        usrimg : maap["Usr Image"],
        uid : maap['User ID'],
        text : maap["Text"],
        postid : maap["Post ID"],
        bgnumber : maap["Background Number"],
        name : maap["Full Name"]);
  }
}
