import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_app/app/modules/home/views/main_view.dart';

class LoginController extends GetxController {
  final RxBool obscureText = true.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Email tidak boleh kosong.");
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Password tidak boleh kosong.");
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.snackbar("Success", "Login berhasil!");
      Get.offAll(() => MainPage());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
