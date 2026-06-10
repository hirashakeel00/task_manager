import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/create_task.dart';

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

    RxList<String> members = <String>[].obs;
    RxList<String> subTasks = <String>[].obs; 
    RxList<bool> checkedTasks = <bool>[].obs;
  RxList<TaskModel> tasks = <TaskModel>[].obs;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);

  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final memberController = TextEditingController();
  final subtaskTextEditingController = TextEditingController();

  List<TaskModel> get ongoingTasks =>
      tasks.where((task) => !isTaskCompleted(task)).toList();
  List<TaskModel> get completedTasks =>
      tasks.where((task) => isTaskCompleted(task)).toList();

   @override
  void onInit() {
    super.onInit();

    if (uid == null) return;
      loadTasks();
    
  }

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

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

 CollectionReference get taskRef {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    throw Exception("User not logged in");
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('tasks');
}

 Future<void> loadTasks() async {
  final ref = taskRef;

  // if (ref == null) return;

  final snapshot = await ref.get();

  tasks.value = snapshot.docs
      .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
      .toList();
}

  Future<void> createTask() async {
    TaskModel task = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: titleController.text,
      details: detailController.text,
      member: members.toList(),
      date: selectedDate.value,
      time: selectedTime.value,
      userId: uid,
      subTasks: [],
    );

    await taskRef.doc(task.id.toString()).set(task.toJson());
    tasks.add(task);

    clearFields();
  }

  void addSubTask(int taskId, String title) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex == -1) return;
    tasks[taskIndex].subTasks.add(SubTask(title: title, isCompleted: false));
    taskRef
        .doc(taskId.toString())
        .update(tasks[taskIndex].toJson());
    tasks.refresh();
  }

  void toggleSubTask({required int taskId, required int subTaskIndex}) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;
    tasks[taskIndex].subTasks[subTaskIndex].isCompleted.toggle();
    taskRef
        .doc(taskId.toString())
        .update(tasks[taskIndex].toJson());
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

  Future<void> deleteTask(int taskId) async {
    await taskRef.doc(taskId.toString()).delete();
    tasks.removeWhere((t) => t.id == taskId);
  }

  Future<void> updateTask(int taskId) async {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final updated = TaskModel(
      id: taskId,
      title: titleController.text,
      details: detailController.text,
      member: members.toList(),
      date: selectedDate.value,
      time: selectedTime.value,
      userId: uid,
      subTasks: tasks[index].subTasks,
    );

    await taskRef.doc(taskId.toString()).update(updated.toJson());
    tasks[index] = updated;
  }

  void clearFields() {
    titleController.clear();
    detailController.clear();
    memberController.clear();
    members.clear();
    selectedDate.value = null;
    selectedTime.value = null;
  }

  @override
  void onClose() {
    titleController.dispose();
    subtaskTextEditingController.dispose();
    detailController.dispose();
      memberController.dispose();
    super.dispose();
  }
}
