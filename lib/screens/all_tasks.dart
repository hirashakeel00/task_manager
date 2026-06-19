import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/nav_controller.dart';
import 'package:task_manager/widgets/avatar_list.dart';
import 'package:task_manager/widgets/indicator.dart';
import '../controllers/task_controller.dart';
import 'package:lottie/lottie.dart';

class AllTasks extends StatelessWidget {
  AllTasks({super.key});

  final TaskController taskController = Get.find<TaskController>();
  final NavController navController = Get.find<NavController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(
        backgroundColor: Color(0xFF263238),
        title: const Text(
          "All Tasks",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'PilatExtended',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Obx(() {
        final tasks = taskController.tasks;

        if (tasks.isEmpty) {
          return Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset('assets/animation/nodatafound.json'),
            ),
          );
        }

        return ListView.separated(
          itemCount: tasks.length,
          padding: const EdgeInsets.all(12),
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Container(
              width: double.infinity,
              color: Color(0xFF455A64),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Text(
                            // maxLines: 5,
                            task.title ?? '',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'PilatExtended',
                            ),
                          ),
                        ),
                        Text(
                          'Team members',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        AvatarList(members: task.member ?? []),
                        SizedBox(height: 5),
                        Text(
                          'Due on: ${task.date?.day}/${task.date?.month}/${task.date?.year}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            taskController.deleteTask(task.id!);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Indicator(
                          progressValue: taskController.getTaskProgress(task),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
