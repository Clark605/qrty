import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.background, fit: BoxFit.cover),
          ),
          child,
        ],
      ),
    );
  }
}
