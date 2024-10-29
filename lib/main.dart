import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Pastikan untuk mengimpor firebase_core
import 'package:flutter_application/app/modules/Aunt/views/register_view.dart';

import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan binding sudah diinisialisasi
  await Firebase.initializeApp(); // Inisialisasi Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      home: RegisterView(),
    );
  }
}