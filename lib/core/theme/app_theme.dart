import 'package:flutter/material.dart';
import 'package:qrty/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.titleGrey,
        fontSize: 27,
        fontWeight: FontWeight.normal,
        fontFamily: 'Itim',
      ),
      titleMedium: TextStyle(
        color: AppColors.titleGrey,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'Itim',
      ),
      bodyMedium: TextStyle(
        color: AppColors.bodyGrey,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: 'Itim',
      ),
    ),
  );
}
