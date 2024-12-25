import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/1_home/controllers/home_controller.dart';

class OfflineMessage extends StatelessWidget {
  final ThemeData theme;

  const OfflineMessage({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 100,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 20),
            Text(
              'Oops! No Internet Connection',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Please check your connection and try again.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final ThemeData theme;
  final HomeController controller = Get.find<HomeController>();

  LoadingIndicator({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading.value) {
      // Jika data sedang dimuat, tampilkan loading
      return Center(
        child: CircularProgressIndicator(
          color: theme.primaryColor,
        ),
      );
    } else {
      // Jika data selesai dimuat tapi kosong, tampilkan pesan kosong
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Belum ada hotel yang tersedia.',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
