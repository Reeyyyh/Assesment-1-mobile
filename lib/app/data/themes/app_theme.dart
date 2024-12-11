import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF007BFF),
    hintColor: const Color(0xFF00C853),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    iconTheme: const IconThemeData(
      color: Color(0xFF212121), // Ikon warna abu-abu gelap untuk tema terang
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF212121)),
      bodyMedium: TextStyle(color: Color(0xFF616161)),
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF007BFF),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white), // Warna putih untuk ikon di AppBar
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(const Color(0xFF00C853)),
      trackColor: WidgetStateProperty.all(const Color(0xFFA5D6A7)),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF007BFF),
      secondary: Color(0xFF00C853),
      surface: Color(0xFFFFFFFF),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF0056B3),
    hintColor: const Color(0xFFFF5722),
    scaffoldBackgroundColor: const Color.fromARGB(255, 48, 46, 46),
    iconTheme: const IconThemeData(
      color: Color(0xFFFFFFFF), // Ikon warna putih untuk tema gelap
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
      bodyMedium: TextStyle(color: Color(0xFFB0BEC5)),
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF0056B3),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white), // Warna putih untuk ikon di AppBar
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(const Color(0xFFFF5722)),
      trackColor: WidgetStateProperty.all(const Color(0xFFFFAB91)),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0056B3),
      secondary: Color(0xFFFF5722),
      surface: Color(0xFF1E1E1E),
    ),
  );
}
