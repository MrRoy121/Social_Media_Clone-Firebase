import 'dart:io';
import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rich_social_media/screens/homeScreen/home.screen.dart';
import 'package:rich_social_media/screens/homeScreen/widgets/createpost_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/Post.dart';
import '../../widgets/custom.snackbar.dart';



class EditPost extends StatefulWidget {
  EditPost({super.key, required this.pst});
  Post pst;
  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  bool isfirst = false;
  String uid = "", name = "", email = "",  imgurl = "";
  var _controlller = TextEditingController();
  var focausnode = FocusNode();
  var prefs;
  double fieldheight = 50;
  bool stretch = true,
      bgcolor = true,
      selectedbg = false,
      txtdark = true,expand1 = true, expand2 = true,
      processing = false;
  int bgnumber = 0;

  List<dynamic> Imageurl = [];
  List<File> selectedImages = [];
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
  final picker = ImagePicker();
  double fontsize = 28;

  @override
  void initState() {
    sharedPref();
    super.initState();
  }
  _addData() {
    setState(() {
      _controlller.text = widget.pst.text;
      if(widget.pst.bgnumber!=0){
        selectedbg=true;
      }
      if (widget.pst.bgnumber == 0 ||
          widget.pst.bgnumber == 2 ||
          widget.pst.bgnumber == 9 ||
          widget.pst.bgnumber == 10 ||
          widget.pst.bgnumber == 12 ||
          widget.pst.bgnumber == 13) {
        txtdark = true;
      } else {
        txtdark = false;
      }
      if(widget.pst.text.length==22){
        if(expand1){
          fieldheight += 50;
          expand1 = false;
        }else{
          expand1 = true;
          fieldheight -= 50;
        }
      }else if(widget.pst.text.length==90){
        if(expand2){
          fieldheight += 50;
          expand2 = false;
        }else{
          expand2 = true;
          fieldheight -= 50;
        }
      }
      if (selectedbg) {
        if (widget.pst.text.length > 50) {
          fontsize = 22;
          bgcolor = false;
          selectedbg = false;
        } else {
          bgcolor = true;
          selectedbg = true;
        }
      } else {
        if (widget.pst.text.length > 100) {
          fontsize = 16;
        } else if (widget.pst.text.length > 50) {
          fontsize = 22;
          bgcolor = false;
          selectedbg = false;
        } else {
          fontsize = 28;
          bgcolor = true;
        }
      }


      bgnumber = widget.pst.bgnumber;
      Imageurl  = widget.pst.Imageurls;
    });
  }

  sharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("uid")!;
      name = prefs.getString("name")!;
      email = prefs.getString("email")!;
      imgurl = prefs.getString("usrimg")!;
    });
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
            bgcolor = false;
            selectedbg = false;
            bgnumber = 0;
            txtdark = true;
            FocusScope.of(context).requestFocus(focausnode);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  editdata() async {

    String postid = widget.pst.postid;
    List<String> _downloadUrls = [];

    if(selectedImages.isNotEmpty){
      await Future.forEach(selectedImages, (image) async {
        List<String> words = image.path.toString().split("/");
        Reference ref = FirebaseStorage.instance
            .ref("Documents/$postid/")
            .child(words[words.length-1]);
        final UploadTask uploadTask = ref.putFile(image);
        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        final url = await taskSnapshot.ref.getDownloadURL();
        _downloadUrls.add(url);
      });
    }

    FirebaseFirestore.instance.collection('Posts').doc(postid).update({
      'Full Name': name,
      'User ID': uid,
      'Like': 0,
      'Comment': 0,
      'Post ID':postid,
      'Time': DateTime.now(),
      'Images': _downloadUrls,
      'Text': _controlller.text,
      'Background Number': bgnumber,
    }).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
              (Route<dynamic> route) => false);
      SnackUtil.showSnackBar(
        context: context,
        text: "Posted Successfully",
        textColor: Colors.white,
        backgroundColor: Colors.green,
      );
    });

  }
  deletedata() async {
    String postid = widget.pst.postid;
    FirebaseStorage.instance
        .ref("Documents/$postid/").delete();
    FirebaseFirestore.instance.collection('Posts').doc(postid).delete().then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
              (Route<dynamic> route) => false);
      SnackUtil.showSnackBar(
        context: context,
        text: "Post Deleted Successfully!!",
        textColor: Colors.white,
        backgroundColor: Colors.green,
      );
    });

  }
  @override
  Widget build(BuildContext context) {
    if (!isfirst) {
      _addData();
      isfirst = true;
    }
    Future<bool> _onBackPressed(BuildContext context) async {
      return (await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(title: const Text("Want to Finish Post Edit?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();},
                child: const Text("cancel",
                ),),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                  },
                child: const Text("discard",
                ),),
            ],
          ))) ?? false  ;

    }


    return WillPopScope(
      onWillPop: (() => _onBackPressed(context)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {_onBackPressed(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: AppColors.creamColor,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  processing = true;
                });
                deletedata();
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                    color: Color(0xff0023ff),
                    borderRadius: BorderRadius.circular(5)),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  processing = true;
                });
                editdata();
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                    color: Color(0xff0023ff),
                    borderRadius: BorderRadius.circular(5)),
                child: const Text(
                  "POST",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
          title: const Text(
            "Edit post",
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
        ),
        body: processing
            ? Container(
            color: Colors.white.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ))
            : Column(
          children: [
            Container(
              width: double.infinity,
              height: 0.4,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: DecorationImage(
                            image: NetworkImage(imgurl),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue.withOpacity(0.2)),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  'assets/world.png',
                                  height: 12,
                                  width: 12,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Public",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.blue),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: Colors.blue,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue.withOpacity(0.2)),
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Album",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.blue),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment:
                selectedbg ? Alignment.center : Alignment.topLeft,
                height: selectedbg ?250:fieldheight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      background[bgnumber],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textAlign:
                  selectedbg ? TextAlign.center : TextAlign.start,
                  controller: _controlller,
                  onTap: () {
                    setState(() {
                      stretch = false;
                    });
                  },
                  onChanged: (val) {
                    setState(() {
                      if(val.length==22){
                        if(expand1){
                          fieldheight += 50;
                          expand1 = false;
                        }else{
                          expand1 = true;
                          fieldheight -= 50;
                        }
                      }else if(val.length==90){
                        if(expand2){
                          fieldheight += 50;
                          expand2 = false;
                        }else{
                          expand2 = true;
                          fieldheight -= 50;
                        }
                      }
                      if (selectedbg) {
                        if (val.length > 50) {
                          fontsize = 22;
                          bgcolor = false;
                          selectedbg = false;
                        } else {
                          bgcolor = true;
                          selectedbg = true;
                        }
                      } else {
                        if (val.length > 100) {
                          fontsize = 16;
                        } else if (val.length > 50) {
                          fontsize = 22;
                          bgcolor = false;
                          selectedbg = false;
                        } else {
                          fontsize = 28;
                          bgcolor = true;
                        }
                      }
                    });
                  },
                  focusNode: focausnode,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'What\'s on your mind?',
                      filled: true,
                      fillColor:selectedbg?Colors.transparent:Colors.grey.shade50,
                      hintStyle: TextStyle(
                          color: txtdark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8))),
                  style: TextStyle(
                      fontSize: fontsize,
                      fontWeight: FontWeight.bold,
                      color: txtdark ? Colors.black : Colors.white),
                )),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: selectedImages.isEmpty
                    ? const Center(child: Text(''))
                    : GridView.builder(
                  itemCount: selectedImages.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: FileImage(
                            selectedImages[index],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedImages
                                .remove(selectedImages[index]);
                            if (selectedImages.length == 0) {
                              bgcolor = true;
                            }
                          });
                        },
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            !stretch && bgcolor
                ? Container(
              width: double.infinity,
              height: 35,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: background.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      FocusScope.of(context).requestFocus(focausnode);
                      setState(() {
                        if (index == 0) {
                          bgnumber = 0;
                          selectedbg = false;
                          txtdark = true;
                        } else if (index == 1) {
                          bgnumber = 1;
                          selectedbg = true;
                          txtdark = false;
                        } else if (index == 2) {
                          bgnumber = 2;
                          selectedbg = true;
                          txtdark = true;
                        } else if (index == 3) {
                          bgnumber = 3;
                          selectedbg = true;
                          txtdark = false;
                        } else if (index == 4) {
                          bgnumber = 4;
                          selectedbg = true;
                          txtdark = false;
                        } else if (index == 5) {
                          bgnumber = 5;
                          selectedbg = true;
                          txtdark = false;
                        } else if (index == 6) {
                          bgnumber = 6;
                          selectedbg = true;
                          txtdark = false;
                        } else if (index == 7) {
                          bgnumber = 7;
                          selectedbg = true;
                          txtdark = false;
                        } else if (index == 8) {
                          bgnumber = 8;
                          selectedbg = true;
                          txtdark = false;
                        } else if (index == 9) {
                          bgnumber = 9;
                          selectedbg = true;
                          txtdark = true;
                        } else if (index == 10) {
                          bgnumber = 10;
                          selectedbg = true;
                          txtdark = true;
                        } else if (index == 11) {
                          bgnumber = 11;
                          selectedbg = true;
                          txtdark = false;
                        } else if (index == 12) {
                          bgnumber = 12;
                          selectedbg = true;
                          txtdark = true;
                        } else if (index == 13) {
                          bgnumber = 13;
                          selectedbg = true;
                          txtdark = true;
                        } else if (index == 14) {
                          bgnumber = 14;
                          selectedbg = true;
                          txtdark = false;
                        }
                      });
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: AssetImage(
                            background[index],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.topRight,
                    ),
                  );
                },
              ),
            )
                : const SizedBox(),
            stretch
                ? Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 0.75,
                  margin: const EdgeInsets.only(top: 10),
                  color: Colors.grey,
                ),
                InkWell(
                    onTap: () {
                      getImages();
                    },
                    child: CreatePostItem(
                      cs: Colors.green,
                      ist: Icons.add_photo_alternate_outlined,
                      txt: "Photo/Video",
                    )),
                Container(
                  width: double.infinity,
                  height: 0.4,
                  color: Colors.grey,
                ),
                CreatePostItem(
                  cs: Colors.blue,
                  ist: Icons.bookmark_border,
                  txt: "Tag People",
                ),
                Container(
                  width: double.infinity,
                  height: 0.4,
                  color: Colors.grey,
                ),
                CreatePostItem(
                  cs: Colors.orange,
                  ist: Icons.tag_faces,
                  txt: "Feelings/Activity",
                ),
                Container(
                  width: double.infinity,
                  height: 0.4,
                  color: Colors.grey,
                ),
                CreatePostItem(
                  cs: Colors.redAccent,
                  ist: Icons.location_on_outlined,
                  txt: "Check In",
                ),
                bgcolor
                    ? Container(
                  width: double.infinity,
                  height: 0.4,
                  color: Colors.grey,
                )
                    : const SizedBox(),
                bgcolor
                    ? CreatePostItem(
                  cs: Colors.red,
                  ist: Icons.video_call_outlined,
                  txt: "Live Video",
                )
                    : const SizedBox(),
                bgcolor
                    ? Container(
                  width: double.infinity,
                  height: 0.4,
                  color: Colors.grey,
                )
                    : const SizedBox(),
                bgcolor
                    ? InkWell(
                  onTap: () {
                    setState(() {
                      stretch = false;
                      FocusScope.of(context)
                          .requestFocus(focausnode);
                    });
                  },
                  child: CreatePostItem(
                    cs: Colors.cyanAccent,
                    ist: Icons.text_fields,
                    txt: "Background Colour",
                  ),
                )
                    : SizedBox(),
                bgcolor
                    ? Container(
                  width: double.infinity,
                  height: 0.4,
                  color: Colors.grey,
                )
                    : const SizedBox(),
                CreatePostItem(
                  cs: Colors.blueAccent,
                  ist: Icons.camera_alt,
                  txt: "Camera",
                ),
                Container(
                  width: double.infinity,
                  height: 0.4,
                  color: Colors.grey,
                ),
                bgcolor
                    ? CreatePostItem(
                  cs: Colors.cyan,
                  ist: Icons.gif_box,
                  txt: "GIF",
                )
                    : const SizedBox(),
                bgcolor
                    ? Container(
                  width: double.infinity,
                  height: 0.4,
                  color: Colors.grey,
                )
                    : const SizedBox(),
                bgcolor
                    ? CreatePostItem(
                  cs: Colors.deepOrange,
                  ist: Icons.music_note,
                  txt: "Music",
                )
                    : const SizedBox(),
                Container(
                  width: double.infinity,
                  height: 0.4,
                  color: Colors.grey,
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      getImages();
                    },
                    icon: const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.green,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                      color: Colors.blue,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.tag_faces,
                      color: Colors.orange,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.redAccent,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        stretch = true;
                        focausnode.unfocus();
                      });
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.grey,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
