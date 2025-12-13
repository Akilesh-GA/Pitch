import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryTurquoise = Color(0xFF1ABC9C);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryTurquoise,

    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),

    colorScheme: ColorScheme.light(
      primary: primaryTurquoise,
      secondary: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
    ),
  );
}
