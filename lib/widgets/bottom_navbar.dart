import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 54, 69, 77),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(index: 0, icon: Icons.person, label: "Profile"),
          _navItem(index: 1, icon: Icons.home_filled, label: "Home"),
          _navItem(index: 2, icon: Icons.list, label: "Tasks"),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 25,
            color: isSelected
                ? const Color(0xFFFED36A)
                : const Color(0xFFE3BF64),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFFFED36A)
                  : const Color(0xFFE3BF64),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
