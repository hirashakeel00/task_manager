import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/nav_controller.dart';

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});

  final NavController navController = Get.find<NavController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomAppBar(
        color: const Color.fromARGB(255, 54, 69, 77),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(icon: Icons.home_filled, label: "Home", index: 0),
            _navItem(icon: Icons.list, label: "All Tasks", index: 1),
            _navItem(icon: Icons.person, label: "Profile", index: 2),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = navController.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => navController.changeIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 25,
            color: isSelected ? Color(0xFFFED36A) : Colors.white,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFFFED36A) : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
