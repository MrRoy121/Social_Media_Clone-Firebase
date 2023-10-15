import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rich_social_media/screens/homeScreen/home.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../loginScreen/login.screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future _initiateCache() async {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }
  Future _initiateCache1() async {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
  }
  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getBool('user') ?? false;
    if (user) {
      Timer(const Duration(seconds: 3), _initiateCache1);
    }else{
      Timer(const Duration(seconds: 3), _initiateCache);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mirage,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Image.asset("assets/playstore.png",width: 155,height: 155,),
            SizedBox(height: 20,),
            Text(
              'Rich Social Media',
              style: TextStyle(
                color: AppColors.creamColor ,
                fontSize: 32.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
