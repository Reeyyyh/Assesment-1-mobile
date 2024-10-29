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
        preferredSize: const Size.fromHeight(50.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
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
            elevation: 0,
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
                    // Gambar Profil dengan opsi hapus
                    GestureDetector(
                      onTap: () {
                        if (controller.imagePath.value.isEmpty) {
                          // Jika tidak ada gambar, langsung membuka galeri
                          controller.pickImage();
                        } else {
                          // Jika ada gambar, tampilkan dialog konfirmasi
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Foto Profil'),
                                content: const Text(
                                    'Pilih tindakan untuk foto profil Anda.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      controller.removeImage();
                                    },
                                    child: const Text('Hapus Foto'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      controller.pickImage();
                                    },
                                    child: const Text('Ganti Foto'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
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
              const SizedBox(height: 10),

              // Garis Pemisah
              Divider(color: Colors.grey.shade300, thickness: 2),

              const SizedBox(height: 70),
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
                  Get.defaultDialog(
                    radius: 10,
                    backgroundColor: Colors.grey[50],
                    confirmTextColor: Colors.green,
                    cancelTextColor: Colors.red,
                    title: "Konfirmasi",
                    middleText: "Apakah Anda yakin ingin keluar?",
                    textConfirm: "Ya",
                    textCancel: "Tidak",
                    onConfirm: () {
                      controller.logOut();
                      Get.back();
                    },
                    onCancel: () {
                      Get.back();
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }),
    );
  }
}
