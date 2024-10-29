import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/app/modules/Aunt/views/register_view.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var imagePath = ''.obs;
  var imageFile;
  var userName = ''.obs; 

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  void fetchUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      userName.value = doc['namaUser'];
      imagePath.value = doc['profilePicture'] ?? ''; 
    }
  }

  void logOut() async {
    await _auth.signOut();
    Get.offAll(RegisterView());
  }

  // Method untuk memilih gambar
  Future<void> pickImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    imageFile = File(pickedFile.path);
    imagePath.value = pickedFile.path;
    await _saveProfilePicture();
  }
}


  Future<void> _saveProfilePicture() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'profilePicture': imagePath.value,
      });
    }
  }

  // Method untuk menghapus gambar
  Future<void> removeImage() async {
    imageFile = null;
    imagePath.value = '';
    // Hapus gambar dari Firestore
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'profilePicture': FieldValue.delete(),
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserName(); // Ambil nama pengguna saat controller diinisialisasi
  }
}
