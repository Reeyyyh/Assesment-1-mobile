import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/Aunt/views/login_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // Import paket animated_text_kit

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigasi otomatis ke LoginView setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(
        () => LoginView(),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau ikon aplikasi
            Image.asset('assets/Favicon/iconLocal.png'),
            const SizedBox(height: 20),
            // Animasi teks 'Welcome' yang diketik
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'WELCOME', // Teks yang ingin muncul
                      textStyle: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                      speed: const Duration(milliseconds: 200), // Kecepatan mengetik
                    ),
                  ],
                  pause: const Duration(seconds: 1), // Waktu jeda setelah animasi selesai
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Animasi loading menggunakan loading_animation_widget
            LoadingAnimationWidget.flickr(
              rightDotColor: const Color(0xFFFBB800),
              leftDotColor: const Color.fromARGB(255, 13, 84, 159),
              size: 45, // Ukuran animasi
            ),
          ],
        ),
      ),
    );
  }
}
