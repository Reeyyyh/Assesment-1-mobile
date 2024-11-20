import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'dart:io';

class QRScanController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  QRViewController? _qrViewController;
  String scannedResult = ''; // Menyimpan hasil pemindaian
  File? _imageFile; // Menyimpan gambar yang diambil atau dipilih

  // Fungsi untuk memulai pemindaian QR
  void startCamera(QRViewController controller) {
    _qrViewController = controller;
    _qrViewController!.scannedDataStream.listen((scanData) {
      // Set nilai hasil pemindaian
      scannedResult = scanData.code ?? '';
      notifyListeners();
    });
  }

  // Fungsi untuk mengambil gambar dari kamera atau galeri
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      // Memulai pemindaian QR Code dari gambar
      scanQRFromFile(_imageFile!);
    }
    notifyListeners();
  }

  // Fungsi untuk memindai QR Code dari gambar
  Future<void> scanQRFromFile(File imageFile) async {
    try {
      // Placeholder untuk implementasi pemindaian QR
      scannedResult = "Sample scanned result";
    } catch (e) {
      scannedResult = "Error scanning QR code: $e";
    }
    notifyListeners();
  }

  // Fungsi untuk melanjutkan pemindaian
  void resumeCamera() {
    _qrViewController?.resumeCamera();
  }

  File? get imageFile => _imageFile;
}
