import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/data/themes/app_theme_controller.dart';

class ThemeSettingsView extends StatelessWidget {
  const ThemeSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController controller = Get.find(); // Ambil controller yang sudah diinisialisasi

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(
              () => ListTile(
                title: const Text('Light Theme'),
                trailing: Icon(
                  controller.isDarkTheme.value ? Icons.circle_outlined : Icons.check_circle,
                  color: controller.isDarkTheme.value ? Colors.grey : Colors.blue,
                ),
                onTap: () {
                  if (controller.isDarkTheme.value) {
                    controller.toggleTheme(); // Ganti ke Light Theme
                  }
                },
              ),
            ),
            Obx(
              () => ListTile(
                title: const Text('Dark Theme'),
                trailing: Icon(
                  controller.isDarkTheme.value ? Icons.check_circle : Icons.circle_outlined,
                  color: controller.isDarkTheme.value ? Colors.blue : Colors.grey,
                ),
                onTap: () {
                  if (!controller.isDarkTheme.value) {
                    controller.toggleTheme(); // Ganti ke Dark Theme
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
