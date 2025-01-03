import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/4_profile/views/account_view_management.dart';
import 'package:hotel_app/app/modules/4_profile/views/edit_profile_view.dart';
import 'package:hotel_app/app/modules/4_profile/views/theme_setting_view.dart';
import 'package:hotel_app/app/modules/components/custom/appBar.dart';
import '../controllers/profile_controller.dart';
import 'dart:io';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: ClipPath(
          clipper: CustomAppBarClipper(),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: AppBar(
              title: Text(
                'Profile',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Gambar Profil
              GestureDetector(
                onTap: () {
                  if (controller.imagePath.value.isEmpty) {
                    controller.pickImage();
                  } else {
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
                              child: Text('Hapus Foto',
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                controller.pickImage();
                              },
                              child: Text('Ganti Foto',
                                  style: Theme.of(context).textTheme.bodyLarge),
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

              // Nama Pengguna dan Tombol Sapaan
              Text(
                "Hello ${controller.userName.value}",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white // Jika tema gelap, gunakan warna putih
                          : Colors
                              .black, // Jika tema terang, gunakan warna hitam
                    ),
              ),

              const SizedBox(height: 80),

              // Menu Pengaturan
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Personal Info'),
                onTap: () {
                  Get.to(() => EditProfileView());
                },
              ),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme Settings'),
                onTap: () {
                  Get.to(() => const ThemeSettingsView());
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.add),
              //   title: const Text('tambahin data'),
              //   onTap: () {
              //     Get.to(() => FirebaseHotelView());
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Manage Account'),
                onTap: () {
                  Get.to(() => AccountManagementView());
                },
              ),
              ListTile(
                iconColor: Colors.red,
                textColor: Colors.red,
                leading: const Icon(Icons.logout),
                title: const Text('Log Out'),
                onTap: () {
                  Get.defaultDialog(
                    radius: 10,
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
            ],
          ),
        );
      }),
    );
  }
}
