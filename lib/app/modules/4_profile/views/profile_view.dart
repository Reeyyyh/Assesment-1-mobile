import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'dart:io';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0), // Tinggi AppBar
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25.0), // Sudut kiri bawah
            bottomRight: Radius.circular(25.0), // Sudut kanan bawah
          ),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            centerTitle: true,
            elevation: 0, // Menghilangkan shadow
          ),
        ),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header tanpa dekorasi
              Container(
                width: 250,
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gambar Profil
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: const Color.fromARGB(191, 94, 92, 92),
                        backgroundImage: controller.imagePath.value.isNotEmpty
                            ? FileImage(File(controller.imagePath.value))
                            : null,
                        child: controller.imagePath.value.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Nama Pengguna
                    Text(
                      "Hello ${controller.userName.value}",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Ubah warna teks menjadi hitam
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Garis Pemisah
              Divider(color: Colors.grey.shade300, thickness: 1),

              // Menu Pengaturan
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Personal Info'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Security Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Account Settings'),
                onTap: () {},
              ),
              ListTile(
                iconColor: Colors.red,
                textColor: Colors.red,
                leading: const Icon(Icons.logout),
                title: const Text('Log Out'),
                onTap: () {
                  controller.logOut();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}
