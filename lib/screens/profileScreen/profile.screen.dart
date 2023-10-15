import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../widgets/custom.snackbar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _conuserEmail = TextEditingController();
  final _conuserName = TextEditingController();
  final _conuserPass = TextEditingController();
  final _conuserPhone = TextEditingController();
  String? email, phone, pass, name, uid, imgurl;

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
      email = prefs.getString("email")!;
      phone = prefs.getString("phone")!;
      pass = prefs.getString("pass")!;
      imgurl = prefs.getString("usrimg")!;
      _conuserPass.text = pass!;
      _conuserEmail.text = email!;
      _conuserPhone.text = phone!;
      _conuserName.text = name!;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 815;

    return Scaffold(
      backgroundColor: AppColors.mirage,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Profile",
                  style: TextStyle(
                    color: AppColors.creamColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child:Image.network(
                            imgurl!,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 115,
                        left: 110,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 18,
                            ),
                            onPressed: () {
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      margin: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        controller: _conuserName,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: AppColors.creamColor),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColors.creamColor,
                          ),
                          hintText: "Full Name",
                          fillColor: AppColors.mirage,
                          hintStyle: TextStyle(color: AppColors.creamColor),
                          filled: true,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      margin: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        controller: _conuserEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: AppColors.creamColor),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
                          ),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: AppColors.creamColor,
                          ),
                          hintText: "E-Mail",
                          fillColor: AppColors.mirage,
                          hintStyle: TextStyle(color: AppColors.creamColor),
                          filled: true,
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      decoration: BoxDecoration(
                          color: AppColors.mirage,
                          border: Border.all(
                            width: 1,
                            color: AppColors.creamColor,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        children: [
                          Text(
                            "+880",
                            style: TextStyle(color: AppColors.creamColor),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '|',
                            style: TextStyle(
                                fontSize: 26, color: AppColors.creamColor),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: TextField(
                            controller: _conuserPhone,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: AppColors.creamColor),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle:
                                    TextStyle(color: AppColors.creamColor),
                                hintText: 'Phone Number'),
                          ))
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      margin: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        controller: _conuserPass,
                        obscureText: true,
                        style: TextStyle(color: AppColors.creamColor),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
                          ),
                          prefixIcon: Icon(
                            Icons.password,
                            color: AppColors.creamColor,
                          ),
                          hintText: "Password",
                          fillColor: AppColors.mirage,
                          hintStyle: TextStyle(color: AppColors.creamColor),
                          filled: true,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 165,
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.creamColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.black12,
                          ),
                        ),
                        onPressed: () {

                        },
                        child: Text(
                          'Update Profile',
                          style: TextStyle(
                            color: AppColors.mirage,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
