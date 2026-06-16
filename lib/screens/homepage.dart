import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/screens/create_task.dart';
import 'package:task_manager/screens/profile.dart';
import 'package:task_manager/screens/search_task_screen.dart';
import 'package:task_manager/screens/see_all_completed.dart';
import 'package:task_manager/screens/see_all_ongoing.dart';
import 'package:task_manager/screens/task_detail.dart';
import 'package:task_manager/services/api_service.dart';
import 'package:task_manager/widgets/avatar_list.dart';
import 'package:task_manager/widgets/indicator.dart';
import 'package:task_manager/widgets/completed_task.dart';
import 'package:task_manager/widgets/cloudinary_avatar.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? todo;
  String name = '';
  final AuthController authController = Get.find<AuthController>();
  final TaskController taskController = Get.find<TaskController>();
  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      final storedName = data?['name'] as String? ?? '';

      setState(() {
        name = storedName;

        authController.nameController.text = name;
      });

      taskController.profileImageUrl.value =
          data?['profileImage'] as String? ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF263238),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 10),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFED36A),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'PilatExtended',
                  ),
                ),
                // SizedBox(height:20),
              ],
            ),
            GestureDetector(
              onTap: () async {
                await Get.to(() => Profile());
              },
              child: Obx(() {
                return CloudinaryAvatar(
                  radius: 25,
                  imageUrl: taskController.profileImageUrl.value,
                  localFile: taskController.profileImage.value,
                  backgroundColor: Colors.black,
                );
              }),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: GestureDetector(
                onTap: () {
                  Get.to(SearchTaskScreen());
                },
                child: AbsorbPointer(
                  child: SearchBar(
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    hintText: 'Search Tasks',
                    textStyle: WidgetStatePropertyAll(
                      TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    hintStyle: WidgetStatePropertyAll(
                      TextStyle(color: Colors.white),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromRGBO(69, 90, 100, 1),
                    ),
                    elevation: WidgetStatePropertyAll(0),
                    leading: Icon(Icons.search, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 23),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (taskController.completedTasks.isNotEmpty) {
                      Get.to(() => SeeAllCompleted());
                    } else {
                      Get.snackbar(
                        // ignore: deprecated_member_use
                        backgroundColor: Color(0xFFFED36A).withOpacity(0.7),
                        colorText: Color(0xFF263238),
                        'No Tasks',
                        'There are no completed tasks to show',
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFED36A),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 23),
            SizedBox(
              height: 190,
              child: Obx(() {
                if (taskController.completedTasks.isEmpty) {
                  return DelayedDisplay(
                    delay: const Duration(milliseconds: 300),
                    child: const Center(
                      child: Text(
                        'No Data Found',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  );
                }
                return DelayedDisplay(
                  delay: const Duration(seconds: 1),
                  slidingBeginOffset: const Offset(1.0, 0.0),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: taskController.completedTasks.length,
                    itemBuilder: (context, index) {
                      final task = taskController.completedTasks[index];
                      // taskController.ongoingTasks.remove(task);
                      return GestureDetector(
                        onTap: () async {
                          await Get.to(() => TaskDetails(task: task));
                        },
                        child: completedTask(task),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 10);
                    },
                  ),
                );
              }),
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ongoing Projects',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (taskController.ongoingTasks.isNotEmpty) {
                      Get.to(() => SeeAllOngoing());
                    } else {
                      Get.snackbar(
                        // ignore: deprecated_member_use
                        backgroundColor: Color(0xFFFED36A).withOpacity(0.7),
                        colorText: Color(0xFF263238),
                        'No Tasks',
                        'There are no ongoing tasks to show',
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFED36A),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (taskController.ongoingTasks.isEmpty) {
                  return DelayedDisplay(
                    delay: const Duration(milliseconds: 300),
                    child: const Center(
                      child: Text(
                        'No Data Found',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  );
                }
                return Obx(
                  () => DelayedDisplay(
                    delay: const Duration(milliseconds: 500),
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: taskController.ongoingTasks.length,
                      itemBuilder: (context, index) {
                        final task = taskController.ongoingTasks[index];
                        return GestureDetector(
                          onTap: () async {
                            await Get.to(() => TaskDetails(task: task));
                          },
                          child: Container(
                            // height: 160,
                            width: double.infinity,
                            color: Color(0xFF455A64),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      task.member == null ||
                                              task.member!.isEmpty
                                          ? Text(
                                              'No members added',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                          : AvatarList(
                                              members: task.member ?? [],
                                            ),
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
                                        progressValue: taskController
                                            .getTaskProgress(task),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFED36A),
        onPressed: () {
          Get.to(() => CreateTask(isEdit: false));
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
