import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/Post.dart';
import '../../../models/data.dart';


class ReactionWidget extends StatefulWidget {
  Post pst;
  String uid, uname,usrimg;
  int rtnindex;
  ReactionWidget({required this.rtnindex, required this.uid, required this.usrimg,  required this.uname, required this.pst, super.key});

  @override
  State<ReactionWidget> createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends State<ReactionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(50),
      ),
      padding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ReactionButton<String>(
        itemSize: const Size.square(40),
        onReactionChanged: (Reaction<String>? reaction) {
          if (reaction?.value == null) {
            FirebaseFirestore.instance
                .collection('Posts')
                .doc(widget.pst.postid)
                .update({
              'Like': widget.pst.like - 1,
            });
            FirebaseFirestore.instance
                .collection('Reaction')
                .where('Post ID', isEqualTo: widget.pst.postid)
                .where('User ID', isEqualTo: widget.uid)
                .get()
                .then((value) {
              for (var doc in value.docs) {
                FirebaseFirestore.instance
                    .collection('Reaction')
                    .doc(doc.id)
                    .delete();
              }
            });
          }
          else {
            FirebaseFirestore.instance
                .collection('Posts')
                .doc(widget.pst.postid)
                .update({
              'Like': widget.pst.like + 1,
            });

            FirebaseFirestore.instance.collection('Reaction').add({
              'Reaction': reaction?.value,
              'Post ID': widget.pst.postid,
              'User ID': widget.uid,
              'Reaction ID': reactions.indexOf(reaction!),
            });
          }
        },
        reactions: reactions,
        placeholder: widget.rtnindex != -1
            ? reactions[widget.rtnindex]
            : defaultInitialReaction,
        selectedReaction: reactions.first,
      ),
    );
  }
}
