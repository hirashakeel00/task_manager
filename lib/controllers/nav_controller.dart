import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/all_tasks.dart';
import 'package:task_manager/screens/profile.dart';
import 'package:task_manager/screens/homepage.dart';

class NavController extends GetxController {
  var selectedIndex = 1.obs;

  final pages = [
    Profile(),
    HomePage(),
    AllTasks(),
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  Widget get currentPage => pages[selectedIndex.value];
}