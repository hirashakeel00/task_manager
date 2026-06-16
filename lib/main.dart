import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/bindings/initial_binding.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/controllers/nav_controller.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/screens/api_testing.dart';
import 'package:task_manager/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  Get.put(AuthController());
  Get.put(TaskController());
  Get.put(NavController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return SafeArea(top: false, child: child!);
      },
    );
  }
}
