// modules/auth/controllers/register_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.snackbar("Success", "Registration successful!");
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
