import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rich_social_media/screens/forgotpassScreen/forgotpass.screen.dart';
import 'package:rich_social_media/screens/homeScreen/home.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../widgets/custom.snackbar.dart';
import '../signupScreen/signup.screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _conuserEmail = TextEditingController();
  final _conuserPass = TextEditingController();

  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getBool('user') ?? false;
    if (user) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mirage,
      appBar: AppBar(
        backgroundColor: AppColors.mirage,
        elevation: 0,
        automaticallyImplyLeading: false,
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
                          "Welcome back.",
                          style: TextStyle(
                            color: AppColors.creamColor,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "You've been missed!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: AppColors.creamColor,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Form(
                      child: Column(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            margin: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              controller: _conuserEmail,
                              style: TextStyle(color: AppColors.creamColor),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide:
                                      BorderSide(color: AppColors.creamColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide:
                                      BorderSide(color: AppColors.creamColor),
                                ),
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: AppColors.creamColor,
                                ),
                                hintText: "E-Mail",
                                fillColor: AppColors.mirage,
                                hintStyle:
                                    TextStyle(color: AppColors.creamColor),
                                filled: true,
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                                hintStyle:
                                    TextStyle(color: AppColors.creamColor),
                                filled: true,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Forgot Password? ",
                                style: TextStyle(
                                  color: AppColors.creamColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ForgotPass()));
                                },
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: AppColors.creamColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dont't have an account? ",
                    style: TextStyle(
                      color: AppColors.creamColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => SignUpScreen()));
                    },
                    child: Text(
                      'Register',
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
                    login(context: context);
                  },
                  child: Text(
                    'Sign In',
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

  login({required BuildContext context}) async {
    String email = _conuserEmail.text;
    String pass = _conuserPass.text;

    final prefs = await SharedPreferences.getInstance();

    if (email.isEmpty) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Email is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (pass.length < 6) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Password Must Be 6 Digit or Character.",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass)
            .then((value) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(value.user?.uid)
              .get()
              .then((DocumentSnapshot docResults) {
            if (docResults.exists) {
              prefs.setBool('user', true);
              prefs.setString("email", docResults.get("Email") ?? '');
              prefs.setString("phone", docResults.get("Phone") ?? '');
              prefs.setString("pass", docResults.get("Password") ?? '');
              prefs.setString("name", docResults.get("Full Name") ?? '');
              prefs.setString("usrimg", docResults.get('Usr Image') ?? '');
              prefs.setString("uid", docResults.id);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen()),
                  (Route<dynamic> route) => false);
              SnackUtil.showSnackBar(
                context: context,
                text: "Login Successfully",
                textColor: AppColors.creamColor,
                backgroundColor: Colors.green,
              );
            }
          }).catchError((error) => SnackUtil.showSnackBar(
                    context: context,
                    text: "Failed to add user: $error",
                    textColor: AppColors.creamColor,
                    backgroundColor: Colors.red,
                  ));
        });
    }
  }
}
