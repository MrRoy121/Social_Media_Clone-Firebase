import 'package:flutter/material.dart';

class CreatePostItem extends StatelessWidget {
  CreatePostItem({super.key, required this.cs, required this.ist, required this.txt});

  IconData ist;
  String txt;
  Color cs;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Row(
          children: [
            Icon(
              ist,
              color: cs,
            ),
            SizedBox(width: 10,),
            Text(
              txt,
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ],
        ),
      );
  }
}
