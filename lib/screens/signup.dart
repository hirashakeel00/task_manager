import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/homepage.dart';
import 'package:task_manager/screens/login.dart';
import 'package:task_manager/widgets/customtextfield.dart';
import 'package:flutter/gestures.dart';
import 'package:task_manager/controllers/auth_controller.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    authController.nameController.clear();
    authController.emailController.clear();
    authController.passwordController.clear();
    authController.confirmPasswordController.clear();
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'name': name, 'email': email});
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        // ignore: deprecated_member_use
        backgroundColor: Color(0xFFFED36A).withOpacity(0.7),
        colorText: Color(0xFF263238),
        "Error",
        e.message ?? "Signup failed",
      );
      rethrow;
    } catch (e) {
      Get.snackbar(
        // ignore: deprecated_member_use
        backgroundColor: Color(0xFFFED36A).withOpacity(0.7),
        colorText: Color(0xFF263238),
        "Error",
        "Something went wrong",
      );
      rethrow;
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
                DelayedDisplay(
                  delay: const Duration(milliseconds: 300),
                  slidingBeginOffset: const Offset(0, 0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Full Name',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),

                      const SizedBox(height: 10),

                      Customtextfield(
                        textcapitalize: TextCapitalization.sentences,
                        controller: authController.nameController,
                        hintText: 'Enter your full name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full Name is required';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                DelayedDisplay(
                  delay: const Duration(milliseconds: 600),
                  slidingBeginOffset: const Offset(0, 0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email Address',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),

                      const SizedBox(height: 10),

                      Customtextfield(
                        textcapitalize: TextCapitalization.sentences,
                        controller: authController.emailController,
                        hintText: 'Enter your Email Address',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email Address is required';
                          }

                          if (!value.contains('@')) {
                            return 'Enter valid email address';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                DelayedDisplay(
                  delay: const Duration(milliseconds: 600),
                  slidingBeginOffset: const Offset(0, 0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Password',
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                DelayedDisplay(
                  delay: const Duration(milliseconds: 900),
                  slidingBeginOffset: const Offset(0, 0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Confirm Password',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),

                      const SizedBox(height: 10),

                      Obx(
                        () => Customtextfield(
                          textcapitalize: TextCapitalization.sentences,
                          controller: authController.confirmPasswordController,
                          hintText: 'Confirm your password',
                          obscureText:
                              authController.obscureConfirmPassword.value,

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
                            if (value !=
                                authController.passwordController.text) {
                              return 'Passwords do not match';
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                DelayedDisplay(
                  delay: const Duration(milliseconds: 1100),
                  slidingBeginOffset: const Offset(0, 0.2),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: Bounceable(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await registerUser(
                              name: authController.nameController.text.trim(),
                              email: authController.emailController.text.trim(),
                              password: authController.passwordController.text
                                  .trim(),
                            );

                            authController.nameController.clear();
                            authController.emailController.clear();
                            authController.passwordController.clear();
                            authController.confirmPasswordController.clear();

                            Get.snackbar(
                              // ignore: deprecated_member_use
                              backgroundColor: Color(
                                0xFFFED36A,
                                // ignore: deprecated_member_use
                              ).withOpacity(0.7),
                              colorText: Color(0xFF263238),
                              "Success",
                              "Account created",
                            );
                            Get.offAll(() => HomePage());
                          } catch (e) {
                            // error already shown in registerUser
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFED36A),
                          borderRadius: BorderRadius.circular(2),
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
                  ),
                ),

                // const SizedBox(height: 30),

                // Row(
                //   children: [
                //     const Expanded(
                //       child: Divider(color: Color(0xFF546E7A), thickness: 1),
                //     ),

                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 10),

                //       child: const Text(
                //         'Or continue with',
                //         style: TextStyle(
                //           color: Color(0xFF90A4AE),
                //           fontSize: 16,
                //         ),
                //       ),
                //     ),

                //     const Expanded(
                //       child: Divider(color: Color(0xFF546E7A), thickness: 1),
                //     ),
                //   ],
                // ),

                // const SizedBox(height: 30),

                // Container(
                //   width: double.infinity,
                //   height: 55,

                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.white70),
                //   ),

                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,

                //     children: [
                //       Image.asset('assets/icons/google.png', height: 22),

                //       const SizedBox(width: 10),

                //       const Text(
                //         'Google',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 20,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
                              Get.offAll(() => Login());
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
}
