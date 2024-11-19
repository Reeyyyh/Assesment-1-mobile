import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class QRScanController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  String scannedResult = '';  // Menyimpan hasil pemindaian
  File? _imageFile;  // Menyimpan gambar yang diambil atau dipilih

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
      // Implementasi pemindaian QR dari file
      // Anda bisa menggunakan plugin atau pustaka lain untuk ini
      // Berikut hanya placeholder untuk pemindaian QR
      scannedResult = "Sample scanned result";  // Ganti dengan hasil pemindaian sebenarnya
    } catch (e) {
      scannedResult = "Error scanning QR code: $e";
    }
    notifyListeners();
  }

  File? get imageFile => _imageFile;
}
