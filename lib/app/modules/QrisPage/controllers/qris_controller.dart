import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'dart:io';

class QRScanController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  QRViewController? _qrViewController;

  String scannedResult = ''; // Menyimpan hasil pemindaian
  bool isFlashOn = false; // Menyimpan status senter
  
  File? _imageFile; // Menyimpan gambar yang diambil atau dipilih

  // Fungsi untuk memulai pemindaian QR
  void startCamera(QRViewController controller) {
    _qrViewController = controller;
    _qrViewController!.scannedDataStream.listen((scanData) {
      // Set nilai hasil pemindaian
      scannedResult = scanData.code ?? '';
      notifyListeners();
      _launchURL(scannedResult);
    });
  }

  // Fungsi untuk mengambil gambar dari kamera atau galeri
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    print('Picked file: $pickedFile');
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      print('Image file path: ${_imageFile!.path}');
      // Memulai pemindaian QR Code dari gambar
      await scanQRFromFile(_imageFile!);
    } else {
      print('No file selected.');
    }
    notifyListeners();
  }

  // Fungsi untuk memindai QR Code dari gambar
  Future<void> scanQRFromFile(File imageFile) async {
    try {
      print('Scanning QR code from file: ${imageFile.path}');
      final result = await QrCodeToolsPlugin.decodeFrom(imageFile.path);
      scannedResult = result ?? "No QR code found";
      print('Scan result: $scannedResult');
      _launchURL(scannedResult);
    } catch (e) {
      scannedResult = "Error scanning QR code: $e";
      print(scannedResult);
    }
    notifyListeners();
  }

  // Fungsi untuk menyalakan/mematikan senter
  void toggleFlash() {
    if (_qrViewController != null) {
      _qrViewController!.toggleFlash();
      isFlashOn = !isFlashOn;
      print('Flash is now ${isFlashOn ? 'ON' : 'OFF'}');
      notifyListeners();
    }
  }

  // Fungsi untuk membuka URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      throw 'Could not launch $url';
    }
  }

  File? get imageFile => _imageFile;
}
