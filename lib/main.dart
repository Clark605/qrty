import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_constants.dart';
import 'package:qrty/core/routes/app_router.dart';
import 'package:qrty/core/routes/routes.dart';
import 'package:qrty/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      path: AppConstants.translationsPath,
      supportedLocales: AppConstants.supportedLocales,
      fallbackLocale: AppConstants.englishLocale,
      child: DevicePreview(
        availableLocales: AppConstants.supportedLocales,
        builder: (context) => MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
            MediaQuery.textScalerOf(context).scale(1.0).clamp(0.85, 1.2),
          ),
        ),
        child: MaterialApp(
          key: ValueKey(context.locale.toString()),
          title: 'QRty',
          theme: AppTheme.appTheme,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,
          initialRoute: Routes.appSection,
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    );
  }
}
