import 'package:flutter/material.dart';
import 'package:qrty/core/routes/routes.dart';
import 'package:qrty/feature/splash/splash_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
