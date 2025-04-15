import 'dart:async';

import 'package:carsilla/const/assets.dart';
import 'package:carsilla/const/common_methods.dart';
import 'package:carsilla/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigate(context);
    super.initState();
  }

  Future<void> navigate(BuildContext context) async {
    Timer(const Duration(seconds: 3), () async {
      print('called----');
      final prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('auth_token');
      if(authToken != null){
        if(context.mounted){
          await getCurrentUser(context);
        }
      }
      if(context.mounted){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(origin: 'Splash'),), (route) => false,);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            height: size.width * 0.6,
            width: size.width,
            IconAssets.logo,),
        ),
      ),
    );
  }
}

