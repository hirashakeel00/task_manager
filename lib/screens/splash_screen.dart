import 'package:flutter/material.dart';
import 'startpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkLoginStatus() async {
    // print('splash started');
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    // print("isLoggedIn: $isLoggedIn");

    if (!mounted) return;

    if (isLoggedIn) {
      Get.offAll(() => HomePage());
    } else {
      Get.offAll(() => StartPage());
    }
  }

  @override
  void initState() {
    super.initState();
    // print("Splash initState");
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF263238),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/bro.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 20),

            Image.asset(
              'assets/images/app_img.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
