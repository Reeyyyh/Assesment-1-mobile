import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:hotel_app/app/data/themes/app_theme.dart';

class ThemeController extends GetxController {
  final GetStorage _storage = GetStorage();
  RxBool isDarkTheme = false.obs;

  ThemeController() {
    // preferensi tema yang disimpan di GetStorage
    isDarkTheme.value = _storage.read('isDarkTheme') ?? false;
  }

  ThemeData get currentTheme =>
      isDarkTheme.value ? AppTheme.darkTheme : AppTheme.lightTheme;

  void toggleTheme() {
    isDarkTheme.value = !isDarkTheme.value;
    // Simpan preferensi tema di GetStorage
    _storage.write('isDarkTheme', isDarkTheme.value);
    
    // Ubah tema aplikasi secara langsung
    Get.changeTheme(currentTheme);
  }
}
