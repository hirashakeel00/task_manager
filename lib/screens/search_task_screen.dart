import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/screens/task_detail.dart';

class SearchTaskScreen extends StatelessWidget {
  SearchTaskScreen({super.key});

  final TaskController taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF263238),
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search tasks...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            taskController.searchTasks(value);
          },
        ),
      ),
      body: Obx(() {
        final results = taskController.searchResults;

        if (results.isEmpty) {
          return const Center(
            child: Text(
              'No Tasks Found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final task = results[index];

            return ListTile(
              title: Text(
                task.title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'PilatExtended',
                ),
              ),
              subtitle: Text(
                task.details ?? '',
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () {
                Get.to(() => TaskDetails(task: task));
              },
            );
          },
        );
      }),
    );
  }
}
