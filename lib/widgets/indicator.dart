import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:task_manager/controllers/task_controller.dart';
// import 'package:task_manager/screens/create_task.dart';

class Indicator extends StatelessWidget {
  final double progressValue;
  const Indicator({super.key, required this.progressValue});

  @override
  Widget build(BuildContext context) {

    // int totalTasks = addTaskList.length;
    // int completedTasks = checkedTasks.where((task) => task).length;
    // double progress = totalTasks == 0 ? 0 : completedTasks / totalTasks;
   

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            value: progressValue,
            strokeWidth: 2,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation(Color(0xFFFED36A)),
          ),
        ),
        Text(
          '${(progressValue * 100).toInt()}%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
// ${(progress * 100).toInt()}%'