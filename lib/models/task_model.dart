
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/models/subtask_model.dart';

class TaskModel {
  final String? title;
  final String? details;
  final List<String>? member;
  final DateTime? date;
  final TimeOfDay? time;
  final Image? avatar;
  final int? id;
  final String? userId;
  List<SubTask> subTasks;
  TaskModel({
    this.title,
    this.details,
    this.member,
    this.date,
    this.time,
    this.avatar,
    this.id,
    this.userId,
    required this.subTasks,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'details': details,
    'member': member,
    'date': date?.toIso8601String(),
    'time': time?.format(Get.context!),
    'userId': userId,
    'subTasks': subTasks.map((e) => e.toJson()).toList(),
  };
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      details: json['details'],
      member: List<String>.from(json['member']),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: null,
      userId: json['userId'],
      subTasks: (json['subTasks'] as List? ?? [])
          .map((e) => SubTask.fromJson(e))
          .toList(),
    );
  }
}