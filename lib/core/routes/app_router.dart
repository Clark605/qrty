import 'package:flutter/material.dart';
import 'package:qrty/core/routes/animation_route.dart';
import 'package:qrty/core/routes/routes.dart';
import 'package:qrty/feature/app_section/view/app_section.dart';
import 'package:qrty/feature/splash/splash_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    //final arg = settings.arguments;
    switch (settings.name) {
      case Routes.splash:
        return AnimationRoute(page: SplashScreen());
      case Routes.appSection:
        return AnimationRoute(page: AppSection());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
