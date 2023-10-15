import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

final defaultInitialReaction = Reaction<String>(
  value: null,
  icon: _buildReactionsIcon(
    'assets/reactions/likedef.png',
    const Text(
      'Like',
      style: TextStyle(
        color: Color(0XFFADADAD),
      ),
    ),
  ),
);

final defaultInitialcommentReaction = Reaction<String>(
  value: null,
  icon: _buildReactionsIcon(
    'assets/reactions/nothing.png',
    Text(
      'Like',
      style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800]),
    ),
  ),
);
List<String> background = [
  "assets/background/b1.png",
  "assets/background/b2.png",
  "assets/background/b3.png",
  "assets/background/b4.png",
  "assets/background/b5.png",
  "assets/background/b6.png",
  "assets/background/b7.png",
  "assets/background/b8.png",
  "assets/background/b9.png",
  "assets/background/b10.png",
  "assets/background/b11.png",
  "assets/background/b12.png",
  "assets/background/b13.png",
  "assets/background/b14.png",
  "assets/background/b15.png",
];
final List<Reaction<String>> reactions = [
  Reaction<String>(
    value: 'Like',
    title: _buildEmojiTitle(
      'Like',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/reactions/like.png',
    ),
    icon: _buildReactionsIcon(
      'assets/reactions/like.png',
      const Text(
        'Like',
        style: TextStyle(
          color: Color(0XFF2196F3),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'In love',
    title: _buildEmojiTitle(
      'In love',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/reactions/in-love.png',
    ),
    icon: _buildReactionsIcon(
      'assets/reactions/in-love.png',
      const Text(
        'In love',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Happy',
    title: _buildEmojiTitle(
      'Happy',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/reactions/happy.png',
    ),
    icon: _buildReactionsIcon(
      'assets/reactions/happy.png',
      const Text(
        'Happy',
        style: TextStyle(
          color: Color(0XFF3b5998),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Angry',
    title: _buildEmojiTitle(
      'Angry',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/reactions/angry.png',
    ),
    icon: _buildReactionsIcon(
      'assets/reactions/angry.png',
      const Text(
        'Angry',
        style: TextStyle(
          color: Color(0XFFed5168),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Sad',
    title: _buildEmojiTitle(
      'Sad',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/reactions/sad.png',
    ),
    icon: _buildReactionsIcon(
      'assets/reactions/sad.png',
      const Text(
        'Sad',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
];

final List<Reaction<String>> reactionscomment = [
  Reaction<String>(
    value: 'Like',
    title: _buildEmojiTitle(
      'Like',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/reactions/like.png',
    ),
    icon: _buildReactionsIcon(
      'assets/reactions/nothing.png',
      const Text(
        'Like',
        style: TextStyle(
          color: Color(0XFF2196F3),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'In love',
    title: _buildEmojiTitle(
      'In love',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/reactions/in-love.png',
    ),
    icon: _buildReactionsIcon(
      'assets/reactions/nothing.png',
      const Text(
        'In love',
        style: TextStyle(
          color: Color(0XFFed5168),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Happy',
    title: _buildEmojiTitle(
      'Happy',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/reactions/happy.png',
    ),
    icon: _buildReactionsIcon(
      'assets/reactions/nothing.png',
      const Text(
        'Happy',
        style: TextStyle(
          color: Color(0XFF3b5998),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Angry',
    title: _buildEmojiTitle(
      'Angry',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/reactions/angry.png',
    ),
    icon: _buildReactionsIcon(
      'assets/reactions/nothing.png',
      const Text(
        'Angry',
        style: TextStyle(
          color: Color(0XFFed5168),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Sad',
    title: _buildEmojiTitle(
      'Sad',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/reactions/sad.png',
    ),
    icon: _buildReactionsIcon(
      'assets/reactions/nothing.png',
      const Text(
        'Sad',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
];
Widget _buildEmojiTitle(String title) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.75),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 8,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _buildEmojiPreviewIcon(String path) {
  return Image.asset(path);
}

Widget _buildReactionsIcon(String path, Text text) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(path, height: 20),
        const SizedBox(width: 5),
        text,
      ],
    ),
  );
}
