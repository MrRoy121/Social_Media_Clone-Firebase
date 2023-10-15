import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rich_social_media/screens/homeScreen/widgets/commentscreen.dart';
import 'package:rich_social_media/screens/homeScreen/widgets/reactionwidget.dart';
import '../../../constants/colors.dart';
import '../../../models/Post.dart';
import '../../../models/data.dart';
import '../../../widgets/custom.snackbar.dart';
import '../editpost_screen.dart';
import 'makecommentbutton.dart';
import 'makelike.dart';
import 'makelove.dart';
import 'makesharebutton.dart';
class makeFeed extends StatefulWidget {
  Post pst;
  String uid, uname,usrimg;
  makeFeed({required this.uid, required this.usrimg,  required this.uname, required this.pst, super.key});

  @override
  State<makeFeed> createState() => _makeFeedState();
}

class _makeFeedState extends State<makeFeed> {
  bool isfirst = false;
  int bgnum = 0;
  double fontsize = 16;
  bool txtdark = true;

  String daysBetween(DateTime from, DateTime to) {
    Duration difference = to.difference(from);

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    if (days >= 1) {
      return "$days days Ago";
    } else if (hours >= 1) {
      return "$hours hours Ago";
    } else if (minutes >= 1) {
      return "$minutes minutes Ago";
    } else {
      return "$seconds Seconds Ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    int rtnindex = -1;
    _add() {
      setState(() {
        FirebaseFirestore.instance
            .collection('Reaction')
            .where('Post ID', isEqualTo: widget.pst.postid)
            .where('User ID', isEqualTo: widget.uid)
        .limit(1)
            .get()
            .then((value) {
          for (var doc in value.docs) {
            setState(() {
              rtnindex = doc['Reaction ID'];
              print(rtnindex);
              print(doc['Reaction ID']);
            });
          }
        });
        if (widget.pst.text.toString().length < 50) {
          fontsize = 22;
        }

        bgnum = widget.pst.bgnumber;
        if (bgnum == 0 ||
            bgnum == 2 ||
            bgnum == 9 ||
            bgnum == 10 ||
            bgnum == 12 ||
            bgnum == 13) {
          txtdark = true;
        } else {
          txtdark = false;
        }
      });
    }

    if (!isfirst) {
      _add();
      isfirst = true;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(widget.pst.usrimg),
                            fit: BoxFit.cover)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pst.name,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        daysBetween(widget.pst.date.toDate(), DateTime.now()),
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  size: 30,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  if (widget.uid == widget.pst.uid) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EditPost(pst: widget.pst)));
                  } else {
                    SnackUtil.showSnackBar(
                      context: context,
                      text: "Personal Posts can be edited!",
                      textColor: AppColors.creamColor,
                      backgroundColor: Colors.red.shade200,
                    );
                  }
                },
              )
            ],
          ),
          bgnum != 0
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        background[bgnum],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.pst.text.toString().isNotEmpty
                          ? const SizedBox(
                              height: 20,
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      Text(
                        widget.pst.text,
                        style: TextStyle(
                            fontSize: fontsize,
                            color: txtdark ? Colors.black : Colors.white,
                            height: 1.5,
                            letterSpacing: .7),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.pst.text.toString().isNotEmpty
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    Text(
                      widget.pst.text,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[800],
                          height: 1.5,
                          letterSpacing: .7),
                    ),
                  ],
                ),
          const SizedBox(
            height: 5,
          ),
          widget.pst.Imageurls.length == 1
              ? Container(
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image:
                              NetworkImage(widget.pst.Imageurls[0].toString()),
                          fit: BoxFit.cover)),
                )
              : (widget.pst.Imageurls.length >= 2 &&
                      widget.pst.Imageurls.length <= 4)
                  ? Container(
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.pst.Imageurls.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        widget.pst.Imageurls[index].toString()),
                                    fit: BoxFit.cover)),
                          );
                        },
                      ),
                    )
                  : widget.pst.Imageurls.length > 4
                      ? GridView.builder(
                        itemCount: 4,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 3) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(3),
                                      image: DecorationImage(
                                          image: NetworkImage(widget
                                              .pst.Imageurls[index]
                                              .toString()),
                                          fit: BoxFit.cover)),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(2),
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "+ ${widget.pst.Imageurls.length}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container(
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  image: DecorationImage(
                                      image: NetworkImage(widget
                                          .pst.Imageurls[index]
                                          .toString()),
                                      fit: BoxFit.cover)),
                            );
                          }
                        },
                      )
                      : Container(),
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      CommentScreen(pst: widget.pst, uid: widget.uid,usrimg:widget.usrimg,fname:  widget.uname,)));
            },
            child: Row(
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
                    )
                  ],
                ),
                Text(
                    widget.pst.comment.toString() == "0"
                        ? "No Comments"
                        : "${widget.pst.comment} Comments",
                    style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReactionWidget(usrimg: widget.usrimg,
                pst: widget.pst, uid: widget.uid, uname: widget.uname,rtnindex:rtnindex),
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CommentScreen(pst: widget.pst,usrimg: widget.usrimg, uid: widget.uid,fname:  widget.uname,)));
                  },
                  child: makeCommentButton()),
              makeShareButton(),
            ],
          )
        ],
      ),
    );
  }
}
