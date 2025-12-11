import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/routes/animation_route.dart';
import 'package:qrty/core/routes/routes.dart';
import 'package:qrty/feature/app_section/view/app_section.dart';
import 'package:qrty/feature/qr_view/view_model/qr_view_cubit.dart';
import 'package:qrty/feature/qr_view/data/services/view_service.dart';
import 'package:qrty/feature/qr_view/view/qr_view_screen.dart';
import 'package:qrty/feature/settings/view_model/settings_cubit.dart';
import 'package:qrty/feature/settings/view/settings_screen.dart';
import 'package:qrty/feature/splash/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arg = settings.arguments as Map<String, dynamic>? ?? {};
    switch (settings.name) {
      case Routes.splash:
        return AnimationRoute(page: SplashScreen());
      case Routes.appSection:
        return AnimationRoute(page: AppSection());
      case Routes.qrView:
        return AnimationRoute(
          page: BlocProvider(
            create: (context) => QrViewCubit(ViewService()),
            child: QrResultScreen(
              data: arg['data'] as String,
              timestamp: arg['timestamp'] as DateTime,
              source: arg['source'] as String,
              type: arg['type'] as QRCodeType,
            ),
          ),
        );
      case Routes.settings:
        return AnimationRoute(
          page: BlocProvider(
            create: (context) => SettingsCubit(),
            child: const SettingsScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
