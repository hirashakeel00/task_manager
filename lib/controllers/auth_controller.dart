import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Rxn<User> firebaseUser = Rxn<User>();

  RxBool isPasswordHidden = true.obs;
  RxBool obscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();

    firebaseUser.value = _auth.currentUser;

    _auth.authStateChanges().listen((User? user) {
      firebaseUser.value = user;
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}