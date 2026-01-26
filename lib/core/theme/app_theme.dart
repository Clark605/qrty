import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_fonts.dart';
import 'package:qrty/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get appTheme => ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.secondary,
      hoverColor: AppColors.primary,
      splashColor: AppColors.primary,
      highlightElevation: 12,
      shape: CircleBorder(),
      sizeConstraints: BoxConstraints.tightFor(width: 64, height: 64),
      iconSize: 32,
    ),

    textTheme: TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.titleGrey,
        fontSize: 27,
        fontWeight: FontWeight.normal,
        fontFamily: AppFonts.itim,
        locale: Locale('en'),
      ),
      titleMedium: TextStyle(
        color: AppColors.titleGrey,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: AppFonts.itim,
        locale: Locale('en'),
      ),
      bodyMedium: TextStyle(
        color: AppColors.bodyGrey,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: AppFonts.itim,
        locale: Locale('en'),
      ),
    ),
  );
}
