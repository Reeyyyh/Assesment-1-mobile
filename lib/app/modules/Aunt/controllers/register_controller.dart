import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_app/app/modules/Aunt/views/login_view.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> register() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Nama tidak boleh kosong.");
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Email tidak boleh kosong.");
      return;
    }
    
    if (passwordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Password tidak boleh kosong.");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'namaUser': nameController.text.trim(),
        'email': emailController.text.trim(),
      });

      Get.snackbar("Success", "Registrasi berhasil!");
      Get.offAll(() => LoginView());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
