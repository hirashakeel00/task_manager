import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';

class AllTasks extends StatelessWidget {
  AllTasks({super.key});

  final TaskController taskController = Get.find<TaskController>();

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
        final tasks = taskController.ongoingTasks;

        if (tasks.isEmpty) {
          return const Center(
            child: Text(
              "No Tasks Found",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final task = tasks[index];

            return Card(
              color: Color(0xFFFED36A),
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 125, 146, 157),
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  task.title ?? "No Title",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  task.details ?? "No Description",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  // Get.to(() => TaskDetail(task: task));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
