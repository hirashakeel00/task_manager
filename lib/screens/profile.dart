import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:cloudinary_made_easy/cloudinary_made_easy.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/screens/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/widgets/customtextfield.dart';
import 'package:task_manager/widgets/cloudinary_avatar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TaskController taskController = Get.find<TaskController>();
  final FocusNode nameFocusNode = FocusNode();
  final AuthController authController = Get.find<AuthController>();
  final CloudinaryService cloudinary = CloudinaryService(
    cloudName: 'dffuhbguj',
    uploadPreset: 'profile_uploads',
  );

  final RxBool isEditingName = false.obs;

  final ImagePicker picker = ImagePicker();

  String email = '';
  String name = '';

  Future<String?> uploadProfileImage(XFile imageFile) async {
    try {
      return await cloudinary.uploadFile(imageFile, folder: 'profile_pictures');
    } catch (e) {
      debugPrint("Cloudinary upload error: $e");
      return null;
    }
  }

  Future<void> saveImageUrlToFirestore(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'profileImage': url,
    }, SetOptions(merge: true));
  }

  Future<void> pickFromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final url = await uploadProfileImage(image);
      if (url != null) {
        await saveImageUrlToFirestore(url);
        taskController.profileImage.value = null;
        taskController.profileImageUrl.value = url;
      }
    }
  }

  Future<void> pickFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final url = await uploadProfileImage(image);
      if (url != null) {
        await saveImageUrlToFirestore(url);
        taskController.profileImage.value = null;
        taskController.profileImageUrl.value = url;
      }
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
      final imageUrl = data?['profileImage'] as String? ?? '';

      setState(() {
        name = storedName;
        email = user.email ?? '';

        authController.nameController.text = name;
        authController.emailController.text = email;
      });

      taskController.profileImageUrl.value = imageUrl;
      if (imageUrl.isEmpty) {
        taskController.profileImage.value = null;
      }
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
                  //  CircleAvatar(
                  //     radius: 64,
                  //     backgroundColor: Color(0xFFFED36A),
                  //     child: CircleAvatar(
                  //       radius: 60,
                  //       backgroundColor: Colors.black,
                  //       backgroundImage:
                  //           taskController.profileImage.value != null
                  //           ? FileImage(taskController.profileImage.value!)
                  //           : AssetImage('assets/images/Ellipse.png')
                  //                 as ImageProvider,
                  //     ),
                  //   ),
                  GestureDetector(
                    onTap: () {
                      if (taskController.profileImage.value == null) return;
                      showDialog(
                        context: context,
                        barrierColor: Colors.black87,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Center(
                              child: Image.file(
                                taskController.profileImage.value!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Hero(
                      tag: 'profilePic',
                      child: Obx(() {
                        return CloudinaryAvatar(
                          radius: 60,
                          imageUrl: taskController.profileImageUrl.value,
                          localFile: taskController.profileImage.value,
                          backgroundColor: Colors.black,
                        );
                      }),
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
            Column(
              children: [
                Obx(
                  () => ListTile(
                    tileColor: const Color(0xFF455A64),
                    leading: Image.asset("assets/icons/useradd.png"),
                    title: isEditingName.value
                        ? Customtextfield(
                            expands: false,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              border: InputBorder.none,
                            ),
                            controller: authController.nameController,
                            textcapitalize: TextCapitalization.sentences,
                          )
                        : Text(
                            authController.nameController.text,
                            style: const TextStyle(color: Colors.white),
                          ),

                    trailing: IconButton(
                      icon: Icon(
                        isEditingName.value ? Icons.check : Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (isEditingName.value) {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .update({
                                  'name': authController.nameController.text
                                      .trim(),
                                });
                            setState(() {
                              name = authController.nameController.text.trim();
                            });
                          }
                        }
                        isEditingName.toggle();
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                ListTile(
                  tileColor: const Color(0xFF455A64),
                  leading: Image.asset("assets/icons/usertag.png"),
                  title: Text(
                    email,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 40),
                ListTile(
                  tileColor: const Color(0xFF455A64),
                  leading: Image.asset("assets/icons/lock1.png"),
                  title: const Text(
                    "••••••••",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Bounceable(
          onTap: () async {
            await FirebaseAuth.instance.signOut();

            Get.snackbar(
              // ignore: deprecated_member_use
              backgroundColor: Color(0xFFFED36A).withOpacity(0.7),
              colorText: Color(0xFF263238),
              'Success',
              'Logged out successfully',
              snackPosition: SnackPosition.BOTTOM,
            );

            Get.offAll(() => Login());
          },
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: const BoxDecoration(
              color: Color(0xFFFED36A),
              borderRadius: BorderRadius.zero,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/logoutcurve.png'),
                const SizedBox(width: 10),
                const Text(
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
        ),
      ),
    );
  }
}
