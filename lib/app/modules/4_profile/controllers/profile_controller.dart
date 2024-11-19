import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/Aunt/views/login_view.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var imagePath = ''.obs;
  var userName = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  // Inisialisasi flutter_tts
  final FlutterTts flutterTts = FlutterTts();

  // Fungsi untuk mengucapkan teks menggunakan TTS
  Future<void> _speak(String text) async {
    try {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1);
      await flutterTts.speak(text);
    } catch (e) {
      print("Error saat menggunakan TTS: $e");
    }
  }

  // Fungsi untuk mengambil data user dan memutar sapaan
  void fetchUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      userName.value = doc['namaUser'];
      imagePath.value = doc['profilePicture'] ?? '';
      // Delay untuk memastikan TTS siap digunakan
      Future.delayed(Duration(milliseconds: 500), () {
        _speak("Hello, ${userName.value}");
      });
    }
  }

  // Fungsi untuk memutar sapaan secara manual
  Future<void> speakHello() async {
    if (userName.value.isNotEmpty) {
      await _speak("Hello, ${userName.value}");
    }
  }

  // Fungsi untuk logout
  void logOut() async {
    await _auth.signOut();
    Get.offAll(LoginView());
  }

  // Fungsi untuk memilih gambar profil
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
      await _saveProfilePicture();
    }
  }

  // Fungsi untuk menyimpan foto profil ke Firestore
  Future<void> _saveProfilePicture() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'profilePicture': imagePath.value,
      });
    }
  }

  // Fungsi untuk menghapus gambar profil
  Future<void> removeImage() async {
    imagePath.value = '';
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'profilePicture': FieldValue.delete(),
      });
    }
  }

  // Fungsi untuk mengupdate nama pengguna
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
