import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrty/core/routes/animation_route.dart';
import 'package:qrty/core/routes/routes.dart';
import 'package:qrty/feature/app_section/view/app_section.dart';
import 'package:qrty/feature/scan_qr/cubit/scan_qr_cubit.dart';
import 'package:qrty/feature/scan_qr/view/scan_qr_screen.dart';
import 'package:qrty/feature/splash/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final arg = settings.arguments;
    switch (settings.name) {
      case Routes.splash:
        return AnimationRoute(page: SplashScreen());
      case Routes.appSection:
        return AnimationRoute(page: AppSection());
      case Routes.scanQr:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ScanQrCubit(
              context: context,
              scannerController: MobileScannerController(),
            ),
            child: ScanQrScreen(),
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
