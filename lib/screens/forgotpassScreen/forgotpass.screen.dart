import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rich_social_media/screens/homeScreen/home.screen.dart';
import 'package:rich_social_media/screens/loginScreen/login.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../widgets/custom.snackbar.dart';
import '../signupScreen/signup.screen.dart';

class ForgotPass extends StatefulWidget {
  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _conuserEmail = TextEditingController();
  final _conuserPass = TextEditingController();
  bool enemail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mirage,
      appBar: AppBar(
        backgroundColor: AppColors.mirage,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (enemail) {
              setState(() {
                enemail = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: AppColors.creamColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Find Your Account.",
                          style: TextStyle(
                            color: AppColors.creamColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    !enemail
                        ? Text(
                            "Enter Your Email Address",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.creamColor,
                            ),
                          )
                        : Text(
                            "Enter New Password",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: AppColors.creamColor,
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      child: Column(
                        children: [
                          !enemail
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    controller: _conuserEmail,
                                    style:
                                        TextStyle(color: AppColors.creamColor),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                        borderSide: BorderSide(
                                            color: AppColors.creamColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                        borderSide: BorderSide(
                                            color: AppColors.creamColor),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: AppColors.creamColor,
                                      ),
                                      hintText: "E-Mail",
                                      fillColor: AppColors.mirage,
                                      hintStyle: TextStyle(
                                          color: AppColors.creamColor),
                                      filled: true,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          enemail
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    controller: _conuserPass,
                                    obscureText: true,
                                    style:
                                        TextStyle(color: AppColors.creamColor),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15.0)),
                                        borderSide: BorderSide(
                                            color: AppColors.creamColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15.0)),
                                        borderSide: BorderSide(
                                            color: AppColors.creamColor),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.password,
                                        color: AppColors.creamColor,
                                      ),
                                      hintText: "Password",
                                      fillColor: AppColors.mirage,
                                      hintStyle: TextStyle(
                                          color: AppColors.creamColor),
                                      filled: true,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
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
                    Resetpass(context: context);
                  },
                  child: Text(
                    enemail ? 'Reset' : 'Next',
                    style: TextStyle(
                      color: AppColors.mirage,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Resetpass({required BuildContext context}) async {
    String email = _conuserEmail.text;
    String pass = _conuserPass.text;

    if (!enemail) {
      if (email.isEmpty) {
        SnackUtil.showSnackBar(
          context: context,
          text: "Email is Required",
          textColor: AppColors.creamColor,
          backgroundColor: Colors.red.shade200,
        );
      } else {
        setState(() {
          enemail = true;
        });
      }
    } else {
      if (pass.length < 6) {
        SnackUtil.showSnackBar(
          context: context,
          text: "Password Must Be 6 Digit or Character.",
          textColor: AppColors.creamColor,
          backgroundColor: Colors.red.shade200,
        );
      } else {
        FirebaseFirestore.instance
            .collection('Users')
            .where("Email", isEqualTo: email)
            .limit(1)
            .get()
            .then((qsnp) async {
              print(qsnp.size.toString());
          if (qsnp.size == 0) {
            setState(() {
              enemail = false;
              _conuserPass.clear();
            });
            SnackUtil.showSnackBar(
              context: context,
              text: "No User Found With this Email..",
              textColor: AppColors.creamColor,
              backgroundColor: Colors.red.shade200,
            );
          } else {
            for (var doc in qsnp.docs) {
              await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: email, password: doc['Password'])
                  .then((value) async {
                final user = await FirebaseAuth.instance.currentUser!;
                user.updatePassword(pass).then((_) {
                  FirebaseFirestore.instance.collection('Users').doc(user.uid).update({'Password': pass});
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                  SnackUtil.showSnackBar(
                    context: context,
                    text: "Successfully Changed Password",
                    textColor: AppColors.creamColor,
                    backgroundColor: Colors.green,
                  );
                }).catchError((error) {
                  print("Password can't be changed" + error.toString());
                });
              });
            }
          }
        });
      }
    }
  }
}
