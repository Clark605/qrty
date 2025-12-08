import 'package:flutter/material.dart';
import 'package:qrty/core/theme/app_colors.dart';

class AppTheme {
  final BuildContext context;
  AppTheme(this.context);

  ThemeData get appTheme => ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    textTheme: TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.titleGrey,
        fontSize: 27,
        fontWeight: FontWeight.normal,
        fontFamily: Localizations.localeOf(context).languageCode == 'en'
            ? 'Itim'
            : null,
      ),
      titleMedium: TextStyle(
        color: AppColors.titleGrey,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: Localizations.localeOf(context).languageCode == 'en'
            ? 'Itim'
            : null,
      ),
      bodyMedium: TextStyle(
        color: AppColors.bodyGrey,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: Localizations.localeOf(context).languageCode == 'en'
            ? 'Itim'
            : null,
      ),
    ),
  );
}
