import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/Aunt/views/register_view.dart';
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

  Future<void> removeImage() async {
    imageFile = null;
    imagePath.value = '';
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'profilePicture': FieldValue.delete(),
      });
    }
  }

  // Method untuk memperbarui nama pengguna
  Future<void> updateUserName(String newName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'namaUser': newName,
      });
      userName.value = newName; // Update nama pengguna di controller
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
  }
}
