import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

import '../../../constants/colors.dart';
import '../../../models/Comment.dart';
import '../../../models/Post.dart';
import '../../../models/data.dart';
import '../../../widgets/custom.snackbar.dart';
import 'makelike.dart';
import 'makelove.dart';

class CommentScreen extends StatefulWidget {
  Post pst;
  String uid, fname, usrimg;
  CommentScreen({required this.pst, required this.usrimg,  required this.uid,required this.fname});
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  var contextSS = TextEditingController();
  var focusnode = FocusNode();
  bool showsend = false;
  bool showcolor = false;
  String daysBetween(DateTime from, DateTime to) {
    Duration difference = to.difference(from);

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    if (days > 1) {
      return "$days d";
    } else if (hours > 1) {
      return "$hours h";
    } else if (minutes > 1) {
      return "$minutes m";
    } else {
      return "$seconds s";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    makeLike(),
                    Transform.translate(
                        offset: const Offset(-5, 0), child: makeLove()),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.pst.like.toString(),
                      style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 32,
                    ),
                  ],
                ),
                Image.asset(
                  "assets/reactions/likedef.png",
                  width: 25,
                  height: 25,
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  "Most Relevant",
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 32,
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Comments')
                    .where("Post ID", isEqualTo: widget.pst.postid)
                    .orderBy("Time", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('No Comments Yet!!');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isNotEmpty) {
                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Comment cmt =
                                Comment.fromJson(snapshot.data!.docs[index]);
                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                widget.usrimg),
                                            fit: BoxFit.cover)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          var tf = TextEditingController(
                                              text: cmt.text);
                                          if (widget.uid == cmt.uid) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Edit Or Delete Comment!!'),
                                                    content: Column(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          onChanged: (value) {},
                                                          controller: tf,
                                                          decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                              "Edit Comment"),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                    context)
                                                                    .pop();
                                                              },
                                                              child: Container(
                                                                height: 35,
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                                padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                    5,
                                                                    vertical:
                                                                    5),
                                                                decoration: BoxDecoration(
                                                                    color: const Color(
                                                                        0xff0048ff),
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        5)),
                                                                child: const Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                      14),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                    'Posts')
                                                                    .doc(widget
                                                                    .pst
                                                                    .postid)
                                                                    .update({
                                                                  'Comment': widget
                                                                      .pst
                                                                      .comment -
                                                                      1,
                                                                });

                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                    'Comments')
                                                                    .doc(cmt
                                                                    .commentid)
                                                                    .delete()
                                                                    .then(
                                                                        (value) {
                                                                      Navigator.of(
                                                                          context)
                                                                          .pop();
                                                                      SnackUtil
                                                                          .showSnackBar(
                                                                        context:
                                                                        context,
                                                                        text:
                                                                        "Comment Deleted Successfully",
                                                                        textColor:
                                                                        Colors
                                                                            .white,
                                                                        backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                      );
                                                                    });
                                                              },
                                                              child: Container(
                                                                height: 35,
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                                padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                    5,
                                                                    vertical:
                                                                    5),
                                                                decoration: BoxDecoration(
                                                                    color: const Color(
                                                                        0xffff0000),
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        5)),
                                                                child: const Text(
                                                                  "Delete",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                      14),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                if (tf.text
                                                                    .length >
                                                                    0) {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                      'Comments')
                                                                      .doc(
                                                                      cmt.commentid)
                                                                      .update({
                                                                    'Time':
                                                                    DateTime
                                                                        .now(),
                                                                    'Text':
                                                                    tf.text,
                                                                  }).then((value) {
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop();
                                                                    SnackUtil
                                                                        .showSnackBar(
                                                                      context:
                                                                      context,
                                                                      text:
                                                                      "Comment Updated Successfully",
                                                                      textColor:
                                                                      Colors
                                                                          .white,
                                                                      backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                    );
                                                                  });
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 35,
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                                padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                    5,
                                                                    vertical:
                                                                    5),
                                                                decoration: BoxDecoration(
                                                                    color: const Color(
                                                                        0xff40ff00),
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        5)),
                                                                child: const Text(
                                                                  "Update",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                      14),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          } else {
                                            SnackUtil.showSnackBar(
                                              context: context,
                                              text: "Personal Comments can be edited!",
                                              textColor: AppColors.creamColor,
                                              backgroundColor: Colors.red.shade200,
                                            );
                                          }


                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.grey.shade300),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              80,
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cmt.name,
                                                style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  cmt.text,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                80,
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                daysBetween(
                                                    cmt.date.toDate(),
                                                    DateTime.now()),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[800]),
                                              ),
                                            ),
                                            Transform.translate(
                                              offset: const Offset(-25, 0),
                                              child: Expanded(
                                                flex: 1,
                                                child: ReactionButton<String>(
                                                  itemSize:
                                                      const Size.square(40),
                                                  reactions: reactionscomment,
                                                  placeholder:
                                                      defaultInitialcommentReaction,
                                                  selectedReaction:
                                                      reactionscomment.first,
                                                  onReactionChanged:
                                                      (Reaction<String>?
                                                          value) {},
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                "Reply",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[800]),
                                              ),
                                            ),
                                            const Expanded(
                                              flex: 4,
                                              child: SizedBox(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100)),
                    child: TextField(
                      controller: contextSS,
                      style: const TextStyle(color: Colors.black),
                      onTap: () {
                        setState(() {
                          showsend = true;
                        });
                      },
                      onChanged: (val) {
                        setState(() {
                          if (val.isNotEmpty) {
                            showcolor = true;
                          } else {
                            showcolor = false;
                          }
                        });
                      },
                      focusNode: focusnode,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Comment as ${widget.fname}",
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  showsend
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.black38,
                                size: 28,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(
                                Icons.gif_box_outlined,
                                color: Colors.black38,
                                size: 28,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(
                                Icons.tag_faces_outlined,
                                color: Colors.black38,
                                size: 28,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(
                                Icons.face_retouching_natural_outlined,
                                color: Colors.black38,
                                size: 28,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(
                                Icons.star_outline_sharp,
                                color: Colors.black38,
                                size: 28,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Expanded(child: SizedBox()),
                              InkWell(
                                onTap: () {
                                  const _chars =
                                      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                  Random _rnd = Random();
                                  String getRandomString(int length) =>
                                      String.fromCharCodes(Iterable.generate(
                                          length,
                                          (_) => _chars.codeUnitAt(
                                              _rnd.nextInt(_chars.length))));

                                  FirebaseFirestore.instance
                                      .collection('Posts')
                                      .doc(widget.pst.postid)
                                      .update({
                                    'Comment': widget.pst.comment + 1,
                                  });

                                  String cid = getRandomString(20);
                                  FirebaseFirestore.instance
                                      .collection('Comments')
                                      .doc(cid)
                                      .set({
                                    'Post ID': widget.pst.postid,
                                    'User ID': widget.uid,
                                    'Time': DateTime.now(),
                                    'Comment ID': cid,
                                    'Usr Image':widget.usrimg,
                                    'Text': contextSS.text,
                                    "Full Name": widget.fname,
                                  }).then((value) {
                                    setState(() {
                                      contextSS.clear();
                                      focusnode.unfocus();
                                      showsend = false;
                                      showcolor = false;
                                    });
                                  });
                                },
                                child: Icon(
                                  Icons.send_outlined,
                                  color:
                                      showcolor ? Colors.blue : Colors.black54,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
