import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../widgets/custom.snackbar.dart';
import '../loginScreen/login.screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _conuserEmail = TextEditingController();
  final TextEditingController _conuserName = TextEditingController();
  final TextEditingController _conuserPass = TextEditingController();
  final TextEditingController _conuserPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mirage,
      appBar: AppBar(
        backgroundColor: AppColors.mirage,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: AppColors.creamColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Register",
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Create new account to get started.",
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0)),
                                borderSide:
                                    BorderSide(color: AppColors.creamColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0)),
                                borderSide:
                                    BorderSide(color: AppColors.creamColor),
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0)),
                                borderSide:
                                    BorderSide(color: AppColors.creamColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0)),
                                borderSide:
                                    BorderSide(color: AppColors.creamColor),
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
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0)),
                                borderSide:
                                    BorderSide(color: AppColors.creamColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0)),
                                borderSide:
                                    BorderSide(color: AppColors.creamColor),
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
                      ],
                    ),
                  ],
                ),
              SizedBox(height: MediaQuery.of(context).size.height/7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: AppColors.creamColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                                (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: AppColors.creamColor,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
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
                      signUp(context: context);
                    },
                    child: Text(
                      'Register',
                      style:TextStyle(color:  AppColors.mirage,),
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
      ),
    );
  }

  signUp({required BuildContext context}) async {
    String email = _conuserEmail.text;
    String name = _conuserName.text;
    String pass = _conuserPass.text;
    String phone = _conuserPhone.text;

    if (email.isEmpty) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Email is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (name.isEmpty) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Name Is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (pass.isEmpty) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Password is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (phone.isEmpty) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Phone Number is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    }else if (pass.length<6) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Password Must Be 6 Digit or Character.",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else {
      String usrimg = "https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(1).jpg?alt=media&token=e14ab717-c75d-45b9-947c-2602f7916389&_gl=1*1tj7s46*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5MzE5LjYwLjAuMA..";
      var code = Random().nextInt(9) + 0;
      if(code==1){
        usrimg ="https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(2).jpg?alt=media&token=7b9dcc38-de3f-42b1-96b6-96713fb93eaa&_gl=1*1216kri*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NjUxLjU2LjAuMA..";
      }else if(code==2){
        usrimg ="https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(3).jpg?alt=media&token=473010a8-79ca-496d-8de8-d0870c7435a4&_gl=1*1ktyceo*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NjY1LjQyLjAuMA..";
      }else if(code==3){
        usrimg ="https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(4).jpg?alt=media&token=689c1dcc-9c6d-4465-b7f1-9a0bbdbb0f8b&_gl=1*d4v8po*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5Njk3LjEwLjAuMA..";
      }else if(code==4){
        usrimg ="https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(5).jpg?alt=media&token=1ac20be7-7724-4dad-9c15-5644aca87254&_gl=1*ba812w*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NzA2LjEuMC4w";
      }else if(code==5){
        usrimg ="https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(6).jpg?alt=media&token=830327e4-798e-422b-a105-e0c3b8bdd2cc&_gl=1*1qz7svu*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NzE1LjUyLjAuMA..";
      }else if(code==6){
        usrimg ="https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(7).jpg?alt=media&token=f0934e9c-4e70-4d34-9e76-9aab160ded4e&_gl=1*m1bja5*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NzM2LjMxLjAuMA..";
      }else if(code==7){
        usrimg ="https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(8).jpg?alt=media&token=4fad4f20-8e70-436c-b1a3-31360ab194c1&_gl=1*1k8pi2k*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NzQ1LjIyLjAuMA..";
      }else if(code==8){
        usrimg ="https://firebasestorage.googleapis.com/v0/b/richsocialmedia-7ac0e.appspot.com/o/user%2Fusr%20(9).jpg?alt=media&token=1f98e9d5-db4d-42e5-96b6-9b74ea72d343&_gl=1*1qiutml*_ga*MTEzNzE0OTg0Ni4xNjkwMTc4Njcw*_ga_CW55HF8NVT*MTY5NzM4OTE1MC40MDIuMS4xNjk3Mzg5NzUzLjE0LjAuMA..";
      }

      final prefs = await SharedPreferences.getInstance();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((onValue) {
        String? user = onValue.user?.uid;
        FirebaseFirestore.instance.collection('Users').doc(user).set({
          'Full Name': name,
          'Email': email,
          'Phone': phone,
          'Password': pass,
          'Usr Image':usrimg,
        }).then((value) {
          prefs.setBool('user', true);
          prefs.setString("email", email);
          prefs.setString("phone", phone);
          prefs.setString("pass", pass);
          prefs.setString("name", name);
          prefs.setString("usrimg", usrimg);
          prefs.setString("uid", user!);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                  (Route<dynamic> route) => false);
          SnackUtil.showSnackBar(
            context: context,
            text: "Signup Successfully",
            textColor: AppColors.creamColor,
            backgroundColor: Colors.green,
          );
        })
            //     .catchError((error) => SnackUtil.showSnackBar(
            //   context: context,
            //   text: "Failed to add user: $error",
            //   textColor: AppColors.creamColor,
            //   backgroundColor: Colors.red,
            // ))
            ;
      });
    }
  }
}
