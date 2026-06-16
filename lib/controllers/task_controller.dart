import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/models/subtask_model.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/api_service.dart';

class TaskController extends GetxController {
  final ApiService apiService = ApiService();
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
  RxString profileImageUrl = ''.obs;

  RxList<String> members = <String>[].obs;
  RxList<String> subTasks = <String>[].obs;
  RxList<bool> checkedTasks = <bool>[].obs;
  RxList<TaskModel> tasks = <TaskModel>[].obs;
  final RxList<TaskModel> searchResults = <TaskModel>[].obs;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);

  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final memberController = TextEditingController();
  final subtaskTextEditingController = TextEditingController();

  void searchTasks(String query) {
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    searchResults.value = tasks.where((task) {
      final title = (task.title ?? '').toLowerCase();
      final details = (task.details ?? '').toLowerCase();

      return title.contains(query.toLowerCase()) ||
          details.contains(query.toLowerCase());
    }).toList();
    // searchResults.clear();
  }

  List<TaskModel> get ongoingTasks =>
      tasks.where((task) => !isTaskCompleted(task)).toList();
  List<TaskModel> get completedTasks =>
      tasks.where((task) => isTaskCompleted(task)).toList();

  Future<void> loadProfileImage() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      profileImageUrl.value = '';
      profileImage.value = null;
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (!doc.exists) {
      profileImageUrl.value = '';
      profileImage.value = null;
      return;
    }

    final data = doc.data();
    profileImageUrl.value = data?['profileImage'] as String? ?? '';

    if (profileImageUrl.value.isEmpty) {
      profileImage.value = null;
    }
  }

  @override
  void onInit() {
    super.onInit();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        loadProfileImage();
        loadTasks();
      } else {
        tasks.clear();
        profileImageUrl.value = '';
        profileImage.value = null;
      }
    });
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xFF263238)),
            dialogTheme: DialogThemeData(backgroundColor: Color(0xFF263238)),
          ),

          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: Color(0xFF263238)),
              dialogTheme: DialogThemeData(backgroundColor: Color(0xFF263238)),
            ),
            child: child!,
          ),
        );
      },
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
    final snapshot = await taskRef.get();
    tasks.value = snapshot.docs
        .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<bool> createTask() async {
    if (selectedDate.value == null || selectedTime.value == null) {
      Get.snackbar(
        'Missing Information',
        'Please select both date and time',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFFFED36A),
        colorText: Color(0xFF263238),
      );
      return false;
    }
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

    return true;
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
    clearFields();
  }

  void addSubTask(int taskId, String title) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;
    tasks[taskIndex].subTasks.add(SubTask(title: title, isCompleted: false));
    taskRef.doc(taskId.toString()).update(tasks[taskIndex].toJson());
    tasks.refresh();
  }

  void toggleSubTask({required int taskId, required int subTaskIndex}) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;
    tasks[taskIndex].subTasks[subTaskIndex].isCompleted.toggle();
    taskRef.doc(taskId.toString()).update(tasks[taskIndex].toJson());
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
