import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:hotel_app/app/modules/QrisPage/controllers/qris_controller.dart';


class QRScanView extends StatelessWidget {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Scanner',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          color: Theme.of(context).primaryColor,
        ),
        elevation: 5,
      ),
      body: ChangeNotifierProvider(
        create: (_) => QRScanController(),
        child: Consumer<QRScanController>(
          builder: (context, controller, _) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor, // Warna background sesuai tema
                    Theme.of(context).primaryColorLight, // Sesuaikan dengan warna yang diinginkan
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Area untuk QR Scanner
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: controller.startCamera,
                        ),
                      ),
                    ),
                  ),

                  // Area hasil pemindaian
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor, // Gunakan cardColor dari tema
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SelectableText(
                          controller.scannedResult.isEmpty
                              ? 'Scan a QR Code'
                              : controller.scannedResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: controller.scannedResult.isEmpty
                                ? Theme.of(context).hintColor // Warna hintColor dari tema
                                : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tombol tambahan untuk memilih gambar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () =>
                              controller.pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt, size: 20),
                          label: const Text('Take Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).hintColor, // Gunakan hintColor dari tema
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () =>
                              controller.pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo, size: 20),
                          label: const Text('Choose Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor, // Gunakan primaryColor dari tema
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
