import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/all_tasks.dart';
import 'package:task_manager/screens/homepage.dart';
import 'package:task_manager/screens/profile.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs;

  Widget get currentPage {
    switch (selectedIndex.value) {
      case 0:
        return const HomePage();
      case 1:
        return AllTasks();
      case 2:
        return const Profile();
      default:
        return const HomePage();
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
