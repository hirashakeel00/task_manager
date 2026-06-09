import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/task_controller.dart';

class AvatarList extends StatelessWidget {
  final List<String> members;

  const AvatarList({super.key, required this.members});
   


  @override
  Widget build(BuildContext context) {
     final TaskController taskController = Get.find<TaskController>();
    return SizedBox(
      width: 80,
      height: 20,
      child: Stack(
        children: [
          ...List.generate(members.length > 3 ? 3 : members.length, (
            memberIndex,
          ) {
            return Positioned(
              left: memberIndex * 12,
              child: CircleAvatar(
                radius: 10,
                backgroundImage: AssetImage(
                  taskController.avatars[memberIndex % taskController.avatars.length],
                ),
              ),
            );
          }),

          if (members.length > 3)
            Positioned(
              left: 38,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: const Color(0xFFFED36A),
                child: Text(
                  '+${members.length - 3}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
