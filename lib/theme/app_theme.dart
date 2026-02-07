import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Color(0xFFDDE5A0),
      primaryColor: Colors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
      ),
    );
  }
}