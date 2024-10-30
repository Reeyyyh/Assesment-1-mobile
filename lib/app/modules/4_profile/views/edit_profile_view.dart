import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});

  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController(text: controller.userName.value);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0), // Atur tinggi AppBar sesuai keinginan
        child: ClipPath(
          clipper: CustomAppBarClipper(), // Menggunakan Custom Clipper
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.blueAccent],
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
              backgroundColor: Colors.transparent, // Membuat latar belakang transparan
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul
            const Text(
              'Edit Nama Pengguna',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Input TextField
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Pengguna',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Membulatkan sudut border
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Simpan dan Batal dalam satu baris
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Mengatur jarak antar tombol
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Update nama pengguna di Firestore
                      await controller.updateUserName(_nameController.text);
                      Get.back(); // Kembali ke halaman profile setelah sukses
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Mengatur warna latar belakang tombol
                      padding: const EdgeInsets.symmetric(vertical: 15), // Mengatur padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Membulatkan sudut tombol
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // Mengatur ukuran, gaya, dan warna teks
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Jarak antar tombol
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back(); // Kembali tanpa menyimpan perubahan
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15), // Mengatur padding
                      backgroundColor: Colors.red[200], // Warna latar belakang tombol batal
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Membulatkan sudut tombol
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // Mengatur ukuran, gaya, dan warna teks
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Pemisah
            Divider(color: Colors.grey.shade400, thickness: 1.5), // Garis pemisah
          ],
        ),
      ),
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30); // Turun ke titik sebelum melengkung (disesuaikan)
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 30); // Lengkungkan ke bawah (disesuaikan)
    path.lineTo(size.width, 0); // Garis ke atas
    path.lineTo(0, 0); // Kembali ke titik awal
    path.close(); // Menutup path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}