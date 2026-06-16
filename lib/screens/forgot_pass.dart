import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/widgets/customtextfield.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> resetPassword() async {
    try {
      setState(() => isLoading = true);

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      Get.snackbar("Success", "Password reset email sent. Check your inbox.");

      Get.back();
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Something went wrong");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF263238),
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text(
                "Enter your email to reset password",
                // textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'PilatExtended',
                ),
              ),

              const SizedBox(height: 40),

              Customtextfield(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: "Email"),
                textcapitalize: TextCapitalization.sentences,
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFED36A),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Send Reset Email",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
