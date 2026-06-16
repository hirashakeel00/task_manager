import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/nav_controller.dart';
import 'package:task_manager/widgets/bottom_navbar.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final NavController navcontroller = Get.put(NavController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: navcontroller.currentPage,
        bottomNavigationBar: BottomNavbar(),
      ),
    );
  }
}
