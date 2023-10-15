import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rich_social_media/screens/settingScreen/widgets/icon.style.dart';
import 'package:rich_social_media/screens/settingScreen/widgets/setting.appbar.dart';
import 'package:rich_social_media/screens/settingScreen/widgets/setting.item.dart';
import 'package:rich_social_media/screens/settingScreen/widgets/setting.user.card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../loginScreen/login.screen.dart';
import '../profileScreen/profile.screen.dart';

class SettingScreen extends StatefulWidget {

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String uid = "", name = "", imgurl = "", email = "", imgs = "";
  var prefs;

  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("uid")!;
      name = prefs.getString("name")!;
      email = prefs.getString("email")!;
      imgs = prefs.getString("usrimg")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mirage,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height:20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                "MENU",
                style: TextStyle(
                  color: AppColors.creamColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            UserCard(
              cardColor: Colors.blueGrey,
              userName: name,
              onTap: () {},imgs: imgs,
              useremail: email,
            ),
            const SizedBox(
              height: 10,
            ),
            SettingsItem(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()));
              },
              icons: CupertinoIcons.profile_circled,
              iconStyle: IconStyle(),
              title: 'Profile',
              subtitle: "Modify Your Data",
            ),
            SettingsItem(
              onTap: () {

              },
              icons: CupertinoIcons.bookmark_fill,
              iconStyle: IconStyle(
                backgroundColor: Colors.brown,
              ),
              title: 'Saved',
              subtitle: "Previously Saved Posts!",
            ),
            SettingsItem(
              onTap: () {
              },
              icons: CupertinoIcons.house,
              iconStyle: IconStyle(
                backgroundColor: Colors.deepOrangeAccent,
              ),
              title: 'Marketplace',
              subtitle: "To buy and check available items",
            ),
            SettingsItem(
              onTap: () {

               },
              icons: Icons.info_rounded,
              iconStyle: IconStyle(
                backgroundColor: Colors.purple,
              ),
              title: 'About',
              subtitle: "Learn more about the App",
            ),
            SettingsItem(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return  AlertDialog(
                      title: Text(
                        "Are You Sure You Want To Logout ?",
                        style: TextStyle(
                          color: AppColors.creamColor,
                          fontSize: 18,
                        ),
                      ),
                      content: Text(
                        "You Will Regret About It!",
                        style: TextStyle(
                          color: AppColors.creamColor,
                          fontSize: 16,
                        ),
                      ),
                      backgroundColor: AppColors.mirage,
                      actions: [
                        TextButton(
                          child: const Text(
                            "No",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueAccent,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            prefs.setBool('user', false);
                            prefs.setString("email", "");
                            prefs.setString("phone", "");
                            prefs.setString("pass", "");
                            prefs.setString("name", "");
                            prefs.setString("usrimg", "");
                            prefs.setString("uid", "");
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                                    (Route<dynamic> route) => false);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icons: Icons.logout,
              iconStyle: IconStyle(
                backgroundColor: Colors.red,
              ),
              subtitle: "Bye Bye",
              title: "Sign Out",
            ),
          ],
        ),
      ),
    );
  }
}
