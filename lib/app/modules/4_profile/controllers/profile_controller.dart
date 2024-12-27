import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/data/connections/controllers/connectivity_controller.dart';
import 'package:hotel_app/app/modules/Aunt/views/login_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  var imagePath = ''.obs;
  var userName = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  final FlutterTts flutterTts = FlutterTts();
  final box = GetStorage(); // Menyimpan data lokal

  final ConnectivityController connectivityController =
      Get.find<ConnectivityController>(); // Mengakses ConnectivityController

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
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      userName.value = doc['namaUser'];
      // Delay untuk memastikan TTS siap digunakan
      Future.delayed(const Duration(milliseconds: 500), () {
        _speak("Hello, ${userName.value}");
      });
    }
  }

  // Fungsi untuk menyimpan foto profil
  Future<void> _saveProfilePicture() async {
    box.write('profilePicture', imagePath.value);
    imagePath.value = box.read('profilePicture');
  }

  // Fungsi untuk memilih gambar profil
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
      await _saveProfilePicture();
    }
  }

  // Fungsi untuk menghapus gambar profil
  Future<void> removeImage() async {
    imagePath.value = '';
    box.remove('profilePicture');
  }

  // Fungsi untuk mengupdate nama pengguna ke Firebase atau lokal
  Future<void> updateUserName(String newName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      if (!connectivityController.isOffline.value) {
        // Jika online, simpan ke Firebase
        print("menu profile online");
        await _firestore.collection('users').doc(user.uid).update({
          'namaUser': newName,
        });
      } else {
        // Jika offline, simpan ke lokal
        print("menu profile offline");
        box.write('userName', newName);
      }
      userName.value = newName;
    }
  }

  // Fungsi untuk menghapus akun
  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await user.delete();
        Get.snackbar('Sukses', 'Akun berhasil dihapus.');
      } else {
        Get.snackbar('Error', 'Tidak ada pengguna yang sedang login.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus akun: $e');
    }
  }

  // Fungsi untuk logout
  void logOut() async {
    await _auth.signOut();
    Get.offAll(LoginView());
  }

  void syncLocalDataToFirebase() async {
    if (!connectivityController.isOffline.value) {
      print("Local data online");

      // Cek jika ada data lokal yang perlu disinkronkan
      if (box.read('userName') != null) {
        String? name = box.read('userName');

        User? user = _auth.currentUser;
        if (user != null) {
          // Sinkronisasi data lokal ke Firebase
          await _firestore.collection('users').doc(user.uid).update({
            'namaUser': name,
          });

          // Tampilkan snackbar setelah data berhasil disinkronkan
          Get.snackbar(
            "Data Sinkronisasi",
            "Data Anda telah berhasil disinkronkan ke server.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
    // Memantau perubahan status koneksi
    connectivityController.isOffline.listen((isOffline) {
      if (!isOffline) {
        syncLocalDataToFirebase();
      }
    });
  }
}
