// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/forgot_pass.dart';
import 'package:task_manager/screens/homepage.dart';
import 'package:flutter/gestures.dart';
import 'package:task_manager/screens/signup.dart';
import 'package:task_manager/widgets/customtextfield.dart';
import 'package:task_manager/controllers/auth_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final AuthController authController = Get.find<AuthController>();
  bool isLoading = false;
  bool isSubmitted = false;

  Future<bool> login(String email, String password) async {
    try {
      setState(() => isLoading = true);
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user != null;
    } catch (e) {
      return false;
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(backgroundColor: Color(0xFF263238), toolbarHeight: 10),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: isLoading,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/bro.png',
                            width: 70,
                            height: 70,
                          ),
                          Image.asset(
                            'assets/images/app_img.png',
                            width: 120,
                            height: 120,
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      DelayedDisplay(
                        delay: const Duration(milliseconds: 300),
                        slidingBeginOffset: const Offset(0, 0.2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: AlignmentGeometry.centerLeft,
                              child: Text(
                                // textAlign: TextAlign.left,
                                'Email Address',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Color.fromARGB(255, 251, 252, 253),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Customtextfield(
                              controller: authController.emailController,
                              textcapitalize: TextCapitalization.none,
                              autovalidateMode: isSubmitted
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF455A64),
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: 'Enter your Email Address',
                              ),
                              onChanged: (_) {
                                if (isSubmitted) {
                                  setState(() {
                                    isSubmitted = false;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                }

                                final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );

                                if (!emailRegex.hasMatch(value.trim())) {
                                  return 'Enter a valid email address';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      DelayedDisplay(
                        delay: const Duration(milliseconds: 600),
                        slidingBeginOffset: const Offset(0, 0.2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: AlignmentGeometry.centerLeft,
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Color.fromARGB(255, 248, 248, 249),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Obx(
                              () => Customtextfield(
                                textcapitalize: TextCapitalization.sentences,
                                autovalidateMode: isSubmitted
                                    ? AutovalidateMode.onUserInteraction
                                    : AutovalidateMode.disabled,
                                controller: authController.passwordController,
                                style: TextStyle(color: Colors.white),
                                obscureText:
                                    authController.isPasswordHidden.value,
                                decoration: InputDecoration(
                                  filled: true,
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(69, 90, 100, 1),
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: 'Enter your password',
                                  suffixIcon: IconButton(
                                    color: Color(0xFF8CAAB9),
                                    onPressed: () {
                                      authController.isPasswordHidden.toggle();
                                      setState(() {
                                        isSubmitted = false;
                                      });
                                    },

                                    icon: Icon(
                                      size: 30,
                                      authController.isPasswordHidden.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFF90A4AE),
                                    ),
                                  ),
                                ),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is required";
                                  }
                                  if (value.length < 8) {
                                    return "Password must be at least 8 characters";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8),
                      Align(
                        alignment: AlignmentGeometry.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const ForgotPass());
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF8CAAB9),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 38),
                      DelayedDisplay(
                        delay: const Duration(milliseconds: 900),
                        slidingBeginOffset: const Offset(0, 0.2),
                        child: Bounceable(
                          onTap: isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    isSubmitted = true;
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    bool isValid = await login(
                                      authController.emailController.text
                                          .trim(),
                                      authController.passwordController.text
                                          .trim(),
                                    );
                                    if (isValid) {
                                      authController.emailController.clear();
                                      authController.passwordController.clear();

                                      Get.snackbar(
                                        // ignore: deprecated_member_use
                                        backgroundColor: Color(
                                          0xFFFED36A,
                                          // ignore: deprecated_member_use
                                        ).withOpacity(0.7),
                                        "Success",
                                        "Login successful",
                                        colorText: Color(0xFF263238),
                                      );
                                      Get.offAll(() => HomePage());
                                    } else {
                                      Get.snackbar(
                                        // ignore: deprecated_member_use
                                        backgroundColor: Color(
                                          0xFFFED36A,
                                          // ignore: deprecated_member_use
                                        ).withOpacity(0.7),
                                        "Error",
                                        "Invalid credentials",
                                        colorText: Color(0xFF263238),
                                      );
                                    }
                                  }
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
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),

                      RichText(
                        text: TextSpan(
                          text: "Don't have an account?",
                          style: TextStyle(
                            color: Color(0xFF8CAAB9),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Sign Up',
                              style: TextStyle(
                                color: Color(0xFFFED36A),
                                fontWeight: FontWeight.w500,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.offAll(() => Signup());
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFFED36A)),
              ),
            ),
        ],
      ),
    );
  }
}
