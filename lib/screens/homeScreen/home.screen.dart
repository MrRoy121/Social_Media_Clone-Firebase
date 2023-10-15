import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rich_social_media/screens/homeScreen/widgets/newsfeed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';

import 'package:rich_social_media/constants/colors.dart';

import '../settingScreen/setting.screen.dart';
import 'createpost_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

CollectionReference Rooms = FirebaseFirestore.instance.collection('Rooms');
FirebaseStorage storageRef = FirebaseStorage.instance;

class _HomeScreenState extends State<HomeScreen> {
  String uid = "", name = "", imgs = "";

  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("uid")!;
      name = prefs.getString("name")!;
      imgs = prefs.getString("usrimg")!;
    });
  }

  Future<int> loadId() async {
    int id = await Future.delayed(const Duration(seconds: 7), () => 42);
    return id;
  }



  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabs = [
       Newsfeed(uid: uid,uname: name,imgs: imgs,),
      const ColoredBox(color: Colors.redAccent),
      const ColoredBox(color: Colors.greenAccent),
      SettingScreen(),
    ];

    Future<bool> _onBackPressed(BuildContext context) async {
      return (await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(title: const Text("You Sure You Want to leave the App?", style: TextStyle(fontSize: 16),),
            actions: <Widget>[
              TextButton(

                onPressed: () {
                  Navigator.of(ctx).pop();},
                child: const Text("Cancel",
                ),),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text("Confirm",
                ),),
            ],
          ))) ?? false  ;

    }
    return WillPopScope(
      onWillPop: (() => _onBackPressed(context)),
      child: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'facebook',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2),
            ),
            centerTitle: false,
            actions: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => CreatePost()));
                    },
                    child: Container(
                      width: 35,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.shade300),
                      child: Icon(Icons.add,color: Colors.black,),
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Container(
                    width: 35,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.shade300),
                    child: Icon(Icons.search_rounded,color: Colors.black,),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Container(
                    width: 35,
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.shade300),
                    child: Image.asset("assets/messenger.png"),
                  )
               ],
            bottom: const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(icon: Icon(Icons.home_rounded,)),
                Tab(icon: Icon(Icons.groups_outlined)),
                Tab(icon: Icon(Icons.notifications_none)),
                Tab(icon: Icon(Icons.menu)),
              ],
            ),
          ),
          body: TabBarView(
            children: _tabs,
          ),
        ),
      ),
    );
  }
}
