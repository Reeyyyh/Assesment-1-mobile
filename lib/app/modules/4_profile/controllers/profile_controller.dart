import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/Aunt/views/login_view.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var imagePath = ''.obs;
  var imageFile;
  var userName = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  
  // Inisialisasi flutter_tts
  final FlutterTts flutterTts = FlutterTts();

  void fetchUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      userName.value = doc['namaUser'];
      imagePath.value = doc['profilePicture'] ?? '';
      _speakHello(userName.value); // Menyapa setelah nama diambil
    }
  }

  // Fungsi untuk mengucapkan 'Hello, <username>'
  void _speakHello(String username) async {
    await flutterTts.setLanguage("en-US"); // Set bahasa (opsional)
    await flutterTts.setPitch(1); // Set pitch suara (opsional)
    await flutterTts.speak("Hello, $username"); // Mengucapkan teks
  }

  Future<void> speakHello() async {
    if (userName.value.isNotEmpty) {
      await flutterTts.setLanguage("en-US"); // Set bahasa (opsional)
    await flutterTts.setPitch(1); // Set pitch suara (opsional)
    await flutterTts.speak("Hello"); // Mengucapkan teks
    }
  }

  void logOut() async {
    await _auth.signOut();
    Get.offAll(LoginView());
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

  Future<void> updateUserName(String newName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'namaUser': newName,
      });
      userName.value = newName;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
  }
}
