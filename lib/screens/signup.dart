import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/homepage.dart';
import 'package:task_manager/screens/login.dart';
// import 'package:task_manager/services/firestore_service.dart';
import 'package:task_manager/widgets/customtextfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:task_manager/controllers/auth_controller.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final AuthController authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();

  // final TextEditingController nameController = TextEditingController();

  // final TextEditingController emailController = TextEditingController();

  // final TextEditingController passwordController = TextEditingController();

  // final TextEditingController confirmPasswordController =
  //     TextEditingController();

  // bool obscurePassword = true;
  // bool obscureConfirmPassword = true;
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'email': email,
        'password': password,
      });

      // print("User saved successfully");
    } catch (e) {
      // print("Firestore Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF263238),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/bro.png', width: 70, height: 70),
                    Image.asset(
                      'assets/images/app_img.png',
                      width: 120,
                      height: 120,
                    ),
                  ],
                ),

                // const SizedBox(height: 40),
                Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),
                const Text(
                  'Full Name',
                  style: TextStyle(color: Color(0xFF90A4AE), fontSize: 18),
                ),

                const SizedBox(height: 10),

                Customtextfield(
                  textcapitalize: TextCapitalization.sentences,
                  controller: authController.nameController,
                  hintText: 'Enter your full name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 25),

                const Text(
                  'Email Address',
                  style: TextStyle(color: Color(0xFF90A4AE), fontSize: 18),
                ),

                const SizedBox(height: 10),

                Customtextfield(
                  textcapitalize: TextCapitalization.sentences,
                  controller: authController.emailController,
                  hintText: 'Enter your Email Address',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }

                    if (!value.contains('@')) {
                      return 'Enter valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 25),

                const Text(
                  'Password',
                  style: TextStyle(color: Color(0xFF90A4AE), fontSize: 18),
                ),

                const SizedBox(height: 10),

                Obx(
                  () => Customtextfield(
                    textcapitalize: TextCapitalization.sentences,
                    controller: authController.passwordController,
                    hintText: 'Enter your password',
                    obscureText: authController.isPasswordHidden.value,

                    suffixIcon: IconButton(
                      onPressed: () {
                        authController.isPasswordHidden.toggle();
                      },

                      icon: Icon(
                        authController.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF90A4AE),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }

                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }

                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Confirm Password',
                  style: TextStyle(color: Color(0xFF90A4AE), fontSize: 18),
                ),

                const SizedBox(height: 10),

                Obx(
                  () => Customtextfield(
                    textcapitalize: TextCapitalization.sentences,
                    controller: authController.confirmPasswordController,
                    hintText: 'Confirm your password',
                    obscureText: authController.obscureConfirmPassword.value,

                    suffixIcon: IconButton(
                      onPressed: () {
                        authController.obscureConfirmPassword.toggle();
                      },

                      icon: Icon(
                        authController.obscureConfirmPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF90A4AE),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm password';
                      }

                      if (value != authController.passwordController.text) {
                        return 'Passwords do not match';
                      }

                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await registerUser(
                          name: authController.nameController.text.trim(),
                          email: authController.emailController.text.trim(),
                          password: authController.passwordController.text
                              .trim(),
                        );

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        await prefs.setBool('isLoggedIn', true);

                        await prefs.setString(
                          'name',
                          authController.nameController.text.trim(),
                        );

                        // Get.offAll(() => HomePage());
                        authController.nameController.clear();
                        authController.emailController.clear();
                        authController.passwordController.clear();
                        authController.confirmPasswordController.clear();

                        Get.snackbar(
                          'Success',
                          'Account created successfully',
                          snackPosition: SnackPosition.BOTTOM,
                        );

                        Get.offAll(() => HomePage());
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFED36A),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Color(0xFF546E7A), thickness: 1),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),

                      child: const Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Color(0xFF90A4AE),
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const Expanded(
                      child: Divider(color: Color(0xFF546E7A), thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  height: 55,

                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Image.asset('assets/icons/google.png', height: 22),

                      const SizedBox(width: 10),

                      const Text(
                        'Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Color(0xFF90A4AE), fontSize: 16),

                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Color(0xFFFED36A),
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => Login());
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //   Widget customField({
  //     required TextEditingController controller,
  //     required String hint,
  //     Widget? suffixIcon,
  //     bool obscureText = false,
  //     String? Function(String?)? validator,
  //   }) {
  //     return TextFormField(
  //       controller: controller,
  //       obscureText: obscureText,
  //       validator: validator,

  //       style: const TextStyle(color: Colors.white),

  //       decoration: InputDecoration(
  //         hintText: hint,

  //         hintStyle: const TextStyle(color: Colors.white70),

  //         suffixIcon: suffixIcon,

  //         filled: true,
  //         fillColor: const Color(0xFF455A64),

  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(2),
  //           borderSide: BorderSide.none,
  //         ),

  //         errorStyle: const TextStyle(color: Colors.redAccent),
  //       ),
  //     );
  //   }
  // }
}
