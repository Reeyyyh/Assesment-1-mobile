// modules/auth/controllers/register_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_application/app/modules/home/main_page.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

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
      // Buat pengguna baru
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Simpan data pengguna di Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'namaUser': nameController.text.trim(), 
        'email': emailController.text.trim(),
      });

      Get.snackbar("Success", "Registrasi berhasil!");
      Get.offAll(() => const MainPage());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
