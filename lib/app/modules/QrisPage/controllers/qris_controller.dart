import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanController extends ChangeNotifier {
  QRViewController? _qrViewController;

  String scannedResult = ''; // Menyimpan hasil pemindaian
  bool isFlashOn = false; // Menyimpan status senter

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
}
