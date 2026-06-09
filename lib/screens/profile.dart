import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/screens/homepage.dart';
import 'package:task_manager/screens/login.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TaskController taskController = Get.find<TaskController>();
  final ImagePicker picker = ImagePicker();
  String email = '';
  String password = '';
  String name = '';
  Future<void> pickFromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      taskController.profileImage.value = File(image.path);
    }
  }

  Future<void> pickFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      taskController.profileImage.value = File(image.path);
    }
  }

  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  pickFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildProfileTile({
    required String leadingIcon,
    required String title,
    required Widget trailing,
  }) {
    return ListTile(
      tileColor: Color(0xFF455A64),
      textColor: Colors.white,
      leading: Image.asset(leadingIcon),
      title: Text(title),
      trailing: trailing,
    );
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      password = prefs.getString('password') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tileData = [
      {
        "leading": "assets/icons/useradd.png",
        "title": name,
        "trailing": Image.asset('assets/icons/edit.png'),
      },
      {
        "leading": "assets/icons/usertag.png",
        "title": email,
        "trailing": Image.asset('assets/icons/edit.png'),
      },
      {
        "leading": "assets/icons/lock1.png",
        "title": password,
        "trailing": Image.asset('assets/icons/edit.png'),
      },
    ];
    return Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(
        backgroundColor: Color(0xFF263238),
        foregroundColor: Colors.white,
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Spacer()
            Center(
              child: Stack(
                children: [
                  Obx(
                    () => CircleAvatar(
                      radius: 64,
                      backgroundColor: Color(0xFFFED36A),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black,
                        backgroundImage:
                            taskController.profileImage.value != null
                            ? FileImage(taskController.profileImage.value!)
                            : AssetImage('assets/images/Ellipse.png')
                                  as ImageProvider,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: 90,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: 35,
                      height: 35,

                      child: GestureDetector(
                        onTap: () {
                          showImagePickerOptions(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Image.asset(
                            'assets/icons/addsquare.png',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),
            // const SizedBox(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tileData.length,
              itemBuilder: (context, index) {
                return buildProfileTile(
                  leadingIcon: tileData[index]["leading"],
                  title: tileData[index]["title"],
                  trailing: tileData[index]["trailing"],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 40),
            ),

            Spacer(),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                await prefs.setBool('isLoggedIn', false);

                Get.snackbar(
                  'Success',
                  'Logged out successfully',
                  snackPosition: SnackPosition.BOTTOM,
                );

                Get.offAll(() => Login());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFED36A),
                minimumSize: Size(400, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: Row(
                // spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/logoutcurve.png'),
                  SizedBox(width: 10),
                  Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
