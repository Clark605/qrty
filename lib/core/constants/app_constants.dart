import 'dart:ui';

abstract class AppConstants {
  static const String appName = 'QRty';

  static const String translationsPath = 'assets/translations';
  static const Locale englishLocale = Locale('en');
  static const Locale arabicLocale = Locale('ar');
  static const List<Locale> supportedLocales = [englishLocale, arabicLocale];
}
