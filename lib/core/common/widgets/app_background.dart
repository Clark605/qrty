import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(AppAssets.background)),
        child,
      ],
    );
  }
}
