import 'package:flutter/material.dart';
import 'package:hotel_app/app/modules/QrisPage/controllers/qris_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class QRScanView extends StatelessWidget {
  const QRScanView({super.key});

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
            title: const Text(
              'QR Scanner',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => QRScanController(), // Menyediakan controller
        child: Consumer<QRScanController>(
          builder: (context, controller, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Menampilkan gambar yang dipilih
                    if (controller.imageFile != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12), // Membuat sudut gambar membulat
                          child: Image.file(
                            controller.imageFile!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    // Menampilkan hasil pemindaian
                    Text(
                      controller.scannedResult.isEmpty
                          ? 'Scan a QR Code'
                          : 'Scanned Result: ${controller.scannedResult}',
                      style: TextStyle(
                        fontSize: 18,
                        color: controller.scannedResult.isEmpty
                            ? Colors.black
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Tombol untuk memilih gambar atau foto
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => controller.pickImage(ImageSource.camera),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), backgroundColor: Colors.green, // Warna tombol hijau
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt, size: 20),
                              SizedBox(width: 8),
                              Text('Take Photo'),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => controller.pickImage(ImageSource.gallery),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), backgroundColor: Colors.blue, // Warna tombol biru
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.photo, size: 20),
                              SizedBox(width: 8),
                              Text('Choose Image'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
