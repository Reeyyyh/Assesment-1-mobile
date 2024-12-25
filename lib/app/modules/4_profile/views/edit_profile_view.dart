import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/components/custom/appBar.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});

  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: controller.userName.value);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: ClipPath(
          clipper: CustomAppBarClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor, 
                  Theme.of(context).colorScheme.secondary
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              title: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Nama Pengguna',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama Pengguna',
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest, // Menggunakan colorScheme untuk fillColor
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
  bool isOffline = controller.connectivityController.isOffline.value;
  await controller.updateUserName(nameController.text);
  Get.back(); // Menutup layar
  Future.delayed(const Duration(milliseconds: 200), () {
    Get.snackbar(
      isOffline ? "Offline Mode" : "Update Berhasil",
      isOffline
          ? "Koneksi internet tidak tersedia. Data Anda disimpan secara lokal."
          : "Nama pengguna berhasil diperbarui secara online.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: isOffline ? Colors.orange : Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  });
},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary, // Menggunakan colorScheme.primary
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      'Simpan',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.2), // Menggunakan colorScheme.error untuk background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Theme.of(context).dividerColor, thickness: 1.5), // Menggunakan dividerColor dari tema
          ],
        ),
      ),
    );
  }
}
