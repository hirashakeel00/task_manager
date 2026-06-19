// import 'dart:math';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/screens/homepage.dart';
import 'package:task_manager/widgets/customtextfield.dart';
import 'package:task_manager/controllers/task_controller.dart';
import '../widgets/member_card.dart';
import 'package:intl/intl.dart';

class CreateTask extends StatefulWidget {
  final bool isEdit;
  final int? index;
  final TaskModel? task;
  const CreateTask({super.key, this.isEdit = false, this.index, this.task});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final TaskController taskController = Get.find<TaskController>();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.task != null) {
      taskController.titleController.text = widget.task!.title ?? '';

      taskController.detailController.text = widget.task!.details ?? '';

      taskController.members.assignAll(widget.task!.member ?? []);

      taskController.selectedDate.value = widget.task!.date ?? DateTime.now();

      taskController.selectedTime.value = widget.task!.time ?? TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF263238),
        title: Text(
          widget.isEdit ? 'Edit Task' : 'Create Task',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    'Task Title',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Customtextfield(
                  textcapitalize: TextCapitalization.sentences,
                  hintText: 'Enter Your Task Title',
                  controller: taskController.titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter task title";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    'Task Details',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Customtextfield(
                  textcapitalize: TextCapitalization.sentences,
                  // maxLines: 3,
                  hintText: 'Write the details of your task',
                  controller: taskController.detailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter task description";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    'Add team members',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  spacing: 25,
                  // runSpacing: 10,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: Obx(
                          () => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: taskController.members.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: memberCard(
                                  taskController.members[index],
                                  () => taskController.removeMember(index),
                                  taskController.avatars[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Color(0xFF455A64),
                              title: Text(
                                "Add your team members",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PilatExtended',
                                ),
                              ),
                              content: Form(
                                key: _formKey1,
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF455A64),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(
                                          0xFF455A64,
                                        ), // Border color when selected
                                      ),
                                    ),
                                    filled: true,
                                    border: OutlineInputBorder(),
                                    fillColor: Color(0xFF36474E),
                                    hintText: 'Enter member name',
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 130, 154, 157),
                                    ),
                                  ),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: taskController.memberController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Field should not be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (_formKey1.currentState!.validate()) {
                                      taskController.addMember();
                                      taskController.memberController.clear();
                                      Get.back();
                                    }
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        color: Color(0xFFFED36A),
                        height: 45,
                        width: 45,
                        child: Image.asset('assets/icons/addsquare.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    'Time & Date',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      taskController.pickTime(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                color: Color(0xFFFED36A),
                                height: 45,
                                width: 40,
                                child: Image.asset('assets/icons/clock.png'),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF455A64),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      taskController.selectedTime.value != null
                                          ? taskController.selectedTime.value!
                                                .format(context)
                                          : 'Time',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    // SizedBox(width: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            taskController.pickDate(context);
                          },
                          child: Row(
                            children: [
                              Container(
                                color: Color(0xFFFED36A),
                                height: 45,
                                width: 45,
                                child: Image.asset('assets/icons/calendar.png'),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF455A64),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      taskController.selectedDate.value != null
                                          ? DateFormat('yyyy-MM-dd').format(
                                              taskController
                                                  .selectedDate
                                                  .value!,
                                            )
                                          : 'Date',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: 55,
          width: double.infinity,
          child: Bounceable(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                bool success = true;

                if (widget.isEdit && widget.task != null) {
                  await taskController.updateTask(widget.task!.id!);
                } else {
                  success = await taskController.createTask();
                }

                if (success) {
                  Get.off(() => HomePage());
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFFED36A),
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                widget.isEdit ? 'Edit Task' : "Create Task",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
