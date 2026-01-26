import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFFFDB623);
  static const Gradient primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0, 1.0],
  );
  static const Color secondary = Color(0xFF333333);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xDD333333);

  static const Color titleGrey = Color(0xD9D9D9D9);
  static const Color bodyGrey = Color(0xA4A4A4A4);

  // Input field colors
  static const Color inputBackground = Color(0xFF444444);
  static const Color inputBorder = Color(0xFF555555);
  static const Color error = Color(0xFFFF6B6B);
}
