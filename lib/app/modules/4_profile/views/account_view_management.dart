import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/Aunt/views/login_view.dart';
import 'package:hotel_app/app/modules/components/custom/appBar.dart';
import '../controllers/profile_controller.dart';

class AccountManagementView extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  AccountManagementView({super.key});

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
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon Peringatan
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.red.withOpacity(0.1),
              child: const Icon(
                Icons.warning_rounded,
                size: 50,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),

            // Teks Informasi
            Text(
              'Peringatan!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Menghapus akun akan menghilangkan semua data Anda secara permanen. '
              'Proses ini tidak dapat dibatalkan.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Tombol Hapus Akun
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 30.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              label: const Text(
                'Hapus Akun',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Get.defaultDialog(
                  radius: 10,
                  title: "Konfirmasi Hapus Akun",
                  titleStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  middleText:
                      "Apakah Anda yakin ingin menghapus akun Anda? Semua data akan hilang.",
                  textConfirm: "Hapus",
                  textCancel: "Batal",
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () async {
                    await controller.deleteAccount();
                    Get.offAll(() => LoginView());
                  },
                  onCancel: () {
                    Get.back();
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            // Tombol Kembali
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
