import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_divider/flutter_text_divider.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/homepage.dart';
import 'package:flutter/gestures.dart';
import 'package:task_manager/screens/signup.dart';
import 'package:task_manager/widgets/customtextfield.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final AuthController authController = Get.find<AuthController>();
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    // print("Entered Email: $email");
    // print("Documents found: ${snapshot.docs.length}");

    if (snapshot.docs.isEmpty) {
      // print('User Not Found');
      return false;
    }

    var user = snapshot.docs.first;
    // print("Firestore Email: ${user['email']}");
    // print("Firestore Password: ${user['password']}");
    // print("Entered Password: $password");


  return user['password'].toString() == password;
  }

  @override
  void initState() {
    super.initState();
    // _passwordVisible = false;
  }

  final _formKey = GlobalKey<FormState>();

  // bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(backgroundColor: Color(0xFF263238), toolbarHeight: 10),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 100),
                      child: Image.asset(
                        'assets/icons/bro.png',
                        width: 70,
                        height: 70,
                      ),
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
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    // textAlign: TextAlign.left,
                    'Email Address',
                    style: TextStyle(fontSize: 19, color: Color(0xFF8CAAB9)),
                  ),
                ),
                SizedBox(height: 8),
                Customtextfield(
                  textcapitalize: TextCapitalization.sentences,
                  controller: authController.emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF455A64),
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Enter your Email Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!value.contains('@')) {
                      return "Enter valid email address";
                    }
                    return null;
                  },
                  // onChanged: () {
                  //   // ('Currenprintt text: $text');
                  // },
                ),

                SizedBox(height: 20),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    // textAlign: TextAlign.left,
                    'Password',
                    style: TextStyle(fontSize: 19, color: Color(0xFF8CAAB9)),
                  ),
                ),
                SizedBox(height: 8),

                // TextField(
                //   decoration: InputDecoration(
                //     filled: true,
                //     fillColor: Color(0xFF455A64),
                //     border: OutlineInputBorder(),
                //   ),
                //   onChanged: (text) {
                //     print('Current text: $text');
                //   },
                // ),
                Obx(
                  () => Customtextfield(
                    textcapitalize: TextCapitalization.sentences,
                    // hintText: '',
                    controller: authController.passwordController,
                    style: TextStyle(color: Colors.white),
                    obscureText: authController.isPasswordHidden.value,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(),
                      fillColor: Color.fromRGBO(69, 90, 100, 1),
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        color: Color(0xFF8CAAB9),
                        onPressed: () {
                          // _passwordVisible = !_passwordVisible;
                          authController.isPasswordHidden.toggle();
                        },
                        icon: Icon(
                          size: 30,
                          authController.isPasswordHidden.value
                              ? Icons.visibility
                              : Icons.visibility_off,
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

                SizedBox(height: 8),
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Text(
                    // textAlign: TextAlign.left,
                    'Forgot Password?',
                    style: TextStyle(fontSize: 17, color: Color(0xFF8CAAB9)),
                  ),
                ),
                SizedBox(height: 38),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        bool isValid = await loginUser(
                          email: authController.emailController.text.trim(),
                          password: authController.passwordController.text.trim(),
                        );

                        if (isValid) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          await prefs.setBool('isLoggedIn', true);

                          await prefs.setString(
                            'email',
                            authController.emailController.text.trim(),
                          );

                          await prefs.setString(
                            'password',
                            authController.passwordController.text.trim(),
                          );

                          authController.emailController.clear();
                          authController.passwordController.clear();

                          Get.snackbar(
                            'Success',
                            'Login successful',
                            snackPosition: SnackPosition.BOTTOM,
                          );

                          Get.offAll(() => HomePage());
                        } else {
                          Get.snackbar(
                            'Login Failed',
                            'Invalid email or password',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                        );

                        // print("Login Error: $e");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFED36A),
                    minimumSize: Size(400, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                // Divider(color: Color(0xFF8CAAB9)),
                TextDivider(
                  text: "Or continue with",
                  color: Color(0xFF8CAAB9),
                  // axis: Axis.vertical,
                  // gap: 12,
                  textStyle: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF8CAAB9),
                  ),
                ),
                SizedBox(height: 40),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white, width: 1.5),
                    // backgroundColor: Color(0xFFFED36A),
                    minimumSize: Size(400, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      Image.asset('assets/icons/google.png'),
                      Text(
                        "Google",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          // fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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
                            Get.to(() => Signup());
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
    );
  }
}
