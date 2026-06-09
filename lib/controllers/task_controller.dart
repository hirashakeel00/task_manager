import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/create_task.dart';

class TaskController extends GetxController {
  final List<String> avatars = [
    'assets/icons/Ellipse 6.png',
    'assets/icons/Ellipse 7.png',
    'assets/icons/Ellipse 8.png',
    'assets/icons/Ellipse 9.png',
    'assets/icons/Ellipse 10.png',
    'assets/icons/Ellipse 20.png',
    'assets/icons/Ellipse 22.png',
  ];

  Rxn<File> profileImage = Rxn<File>();

  RxList<TaskModel> tasks = <TaskModel>[].obs;
  List<TaskModel> get ongoingTasks =>
      tasks.where((task) => !isTaskCompleted(task)).toList();

  List<TaskModel> get completedTasks =>
      tasks.where((task) => isTaskCompleted(task)).toList();

  final titleController = TextEditingController();
  final subtaskTextEditingcontroller = TextEditingController();
  final detailController = TextEditingController();
  final memberController = TextEditingController();
  // RxList<TaskModel> ongoingTasks = <TaskModel>[].obs;
  // RxList<TaskModel> completedTasks = <TaskModel>[].obs;

  RxList<String> members = <String>[].obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  RxList<String> subTasks = <String>[].obs;
  RxList<bool> checkedTasks = <bool>[].obs;

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  void addSubTask(int taskId, String title) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    tasks[taskIndex].subTasks.add(SubTask(title: title, isCompleted: false));

    tasks.refresh();
  }

  void toggleSubTask({required int taskId, required int subTaskIndex}) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);

    if (taskIndex == -1) return;
    // print("Task from tasks list: ${tasks[taskIndex].title}");

    tasks[taskIndex].subTasks[subTaskIndex].isCompleted.toggle();

    tasks.refresh();
  }

  double getTaskProgress(TaskModel task) {
    // final task = tasks[taskIndex];
    if (task.subTasks.isEmpty) return 0;
    int completed = task.subTasks
        .where((subTask) => subTask.isCompleted.value)
        .length;
    // print('completed $completed');
    return completed / task.subTasks.length;
  }

  bool isTaskCompleted(TaskModel task) =>
      // ongoingTasks.remove(task);
      task.subTasks.isNotEmpty &&
      task.subTasks.every((subTask) => subTask.isCompleted.value);

  void addMember() {
    if (memberController.text.trim().isNotEmpty) {
      members.add(memberController.text.trim());
      // print('Members: ${members.value}');
      memberController.clear();
    }
  }

  void removeMember(int index) {
    members.removeAt(index);
  }

  void createTask() {
    TaskModel task = TaskModel(
      title: titleController.text,
      member: members.toList(),
      details: detailController.text,
      date: selectedDate.value,
      time: selectedTime.value,
      id: DateTime.now().millisecondsSinceEpoch,
      // subTasks: [],
    );
    tasks.add(task);
    clearFields();
  }

  void updateTask(int taskId) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) return;

    tasks[index] = TaskModel(
      title: titleController.text,
      details: detailController.text,
      member: members.toList(),
      date: selectedDate.value,
      time: selectedTime.value,
      id: taskId,
      // subTasks: [],
    );
    tasks.refresh();
  }

  void deleteTask(int taskId) {
    tasks.removeWhere((task) => task.id == taskId);
    tasks.refresh();
    Get.back();
  }

  void clearFields() {
    titleController.clear();
    detailController.clear();
    memberController.clear();

    members.clear();

    selectedDate.value = DateTime.now();
    selectedTime.value = TimeOfDay.now();
  }

  @override
  void onClose() {
    titleController.dispose();
    subtaskTextEditingcontroller.dispose();
    detailController.dispose();
    super.dispose();
  }
}
