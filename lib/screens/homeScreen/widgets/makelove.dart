import 'package:flutter/material.dart';


Widget makeLove() {
  return Container(
    width: 25,
    height: 25,
    decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white)
    ),
    child: Center(
      child: Icon(Icons.favorite, size: 12, color: Colors.white),
    ),
  );
}