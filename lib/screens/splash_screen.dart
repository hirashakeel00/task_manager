import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/screens/homepage.dart';
import 'package:task_manager/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user != null) {
      Get.offAll(() => HomePage());
    } else {
      Get.offAll(() => Login());
    }
  }

  @override
  void initState() {
    super.initState();
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
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/app_img.png',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}