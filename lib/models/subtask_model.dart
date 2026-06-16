import 'package:get/get.dart';

class SubTask {
  String title;
  RxBool isCompleted;

  SubTask({required this.title, required bool isCompleted})
    : isCompleted = isCompleted.obs;

  Map<String, dynamic> toJson() {
    return {'title': title, 'isCompleted': isCompleted.value};
  }

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}