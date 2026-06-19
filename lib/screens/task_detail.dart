import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/screens/create_task.dart';
import 'package:task_manager/widgets/task_tile.dart';
import 'package:task_manager/widgets/avatar_list.dart';
import 'package:task_manager/widgets/indicator.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class TaskDetails extends StatefulWidget {
  final TaskModel task;
  const TaskDetails({super.key, required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final TaskController taskController = Get.find<TaskController>();
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    const yellowColor = Color(0xFFF2C95D);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF263238),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Task Details",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => CreateTask(isEdit: true, task: widget.task));
            },
            icon: Image.asset('assets/icons/edit.png', color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Color(0xFF263238),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 20),
              Text(
                widget.task.title ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PilatExtended',
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Due Date and Time",
                            style: TextStyle(
                              color: Color(0xFF8CAAB9),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${widget.task.date?.day}/${widget.task.date?.month}/${widget.task.date?.year}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${widget.task.time?.hour}:${widget.task.time?.minute}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: const Icon(
                          Icons.group_outlined,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Project Team",
                            style: TextStyle(
                              color: Color(0XFF8CAAB9),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          AvatarList(members: widget.task.member ?? []),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                "Project Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),

              Text(
                widget.task.details ?? '',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Project Progress",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(() {
                    final task = taskController.tasks.firstWhereOrNull(
                      (t) => t.id == widget.task.id,
                    );

                    if (task == null) {
                      return const SizedBox();
                    }

                    return Indicator(
                      progressValue: taskController.getTaskProgress(task),
                    );
                  }),
                ],
              ),

              const Text(
                "All Tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                spacing: 20,
                children: [
                  SizedBox(
                    height: 200,
                    child: Obx(() {
                      final task = taskController.tasks.firstWhereOrNull(
                        (t) => t.id == widget.task.id,
                      );
                      if (task == null || task.subTasks.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Subtask Added',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: task.subTasks.length,
                        itemBuilder: (context, index) {
                          final subTask = task.subTasks[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: taskTile(
                              subTask.title,
                              subTask.isCompleted.value,
                              () {
                                taskController.toggleSubTask(
                                  taskId: task.id!,
                                  subTaskIndex: index,
                                );
                              },
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),

              // SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Bounceable(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color(0xFF455A64),
                  title: const Text(
                    "Add the tasks",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PilatExtended',
                    ),
                  ),
                  content: Form(
                    key: _formKey,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF455A64)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF455A64)),
                        ),
                        filled: true,
                        border: OutlineInputBorder(),
                        fillColor: Color(0xFF36474E),
                        hintText: 'Enter the subtasks',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 103, 127, 137),
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field should not be empty";
                        }
                        return null;
                      },
                      controller: taskController.subtaskTextEditingController,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          taskController.addSubTask(
                            widget.task.id!,
                            taskController.subtaskTextEditingController.text,
                          );
                          taskController.subtaskTextEditingController.clear();
                          Get.back();
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: double.infinity,
            height: 55,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFFED36A),
              borderRadius: BorderRadius.zero,
            ),
            child: const Text(
              "Add Task",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
