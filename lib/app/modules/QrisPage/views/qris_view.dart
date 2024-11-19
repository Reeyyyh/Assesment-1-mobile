import 'package:flutter/material.dart';

class QRScanView extends StatelessWidget {
  QRScanView({super.key});

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scan"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
