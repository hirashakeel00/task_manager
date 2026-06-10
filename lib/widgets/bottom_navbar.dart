import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/all_tasks.dart';
import 'package:task_manager/screens/homepage.dart';
import 'package:task_manager/screens/profile.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 54, 69, 77),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            icon: Icons.list,
            label: "All Tasks",
            onTap: () => Get.off(() => AllTasks()),
          ),
          _navItem(
            icon: Icons.home_filled,
            label: "Home",
            onTap: () => Get.off(() => HomePage()),
          ),
          _navItem(
            icon: Icons.person,
            label: "Profile",
            onTap: () => Get.off(() => Profile()),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.circle, // remove this line if not needed
            size: 0,
          ),
          Icon(icon, size: 25, color: const Color(0xFFFED36A)),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(color: Color(0xFFE3BF64), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
