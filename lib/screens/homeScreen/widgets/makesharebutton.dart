import 'package:flutter/material.dart';

Widget makeShareButton() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(50),
    ),
    child: const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.share, color: Colors.grey, size: 18),
          SizedBox(
            width: 5,
          ),
          Text(
            "Share",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    ),
  );
}
