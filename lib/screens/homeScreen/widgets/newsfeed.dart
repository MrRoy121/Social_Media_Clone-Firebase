import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/Post.dart';
import '../createpost_screen.dart';
import 'makefeed.dart';
import 'makestory.dart';

class Newsfeed extends StatefulWidget {
  Newsfeed({required this.uid, required this.uname, required this.imgs,super.key});

  String uid, uname,imgs;

  @override
  State<Newsfeed> createState() => _NewsfeedState();
}

class _NewsfeedState extends State<Newsfeed> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(widget.imgs),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CreatePost()));
                                },
                                child: const TextField(
                                  enabled: false,
                                  decoration: InputDecoration.collapsed(
                                      hintText: 'What\'s on your mind?'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 10.0, thickness: 0.5),
                        SizedBox(
                          height: 40.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton.icon(
                                onPressed: () => print('Live'),
                                icon: const Icon(
                                  Icons.videocam,
                                  color: Colors.red,
                                ),
                                label: const Text('Live'),
                              ),
                              const VerticalDivider(width: 8.0),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.photo_library,
                                  color: Colors.green,
                                ),
                                label: const Text('Photo'),
                              ),
                              const VerticalDivider(width: 8.0),
                              TextButton.icon(
                                onPressed: () => print('Room'),
                                icon: const Icon(
                                  Icons.video_call,
                                  color: Colors.purpleAccent,
                                ),
                                label: const Text('Room'),
                              ),
                              const VerticalDivider(width: 8.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "Stories",
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 1.2),
                      ),
                      const Text("See Archive"),
                    ],
                  ),
                ),
                Container(
                  height: 180,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      makeStory(
                          storyImage: 'assets/story/story-1.jpg',
                          userImage: 'assets/aatik-tasneem.jpg',
                          userName: 'Aatik Tasneem'),
                      makeStory(
                          storyImage: 'assets/story/story-3.jpg',
                          userImage: 'assets/aiony-haust.jpg',
                          userName: 'Aiony Haust'),
                      makeStory(
                          storyImage: 'assets/story/story-4.jpg',
                          userImage: 'assets/averie-woodard.jpg',
                          userName: 'Averie Woodard'),
                      makeStory(
                          storyImage: 'assets/story/story-5.jpg',
                          userImage: 'assets/azamat-zhanisov.jpg',
                          userName: 'Azamat Zhanisov'),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Posts')
                      .orderBy("Time", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
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
                              Post pst =
                              Post.fromJson(snapshot.data!.docs[index]);
                                return makeFeed(usrimg: widget.imgs,
                                    pst: pst, uid: widget.uid, uname: widget.uname,);

                            }),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
