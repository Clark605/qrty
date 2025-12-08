import 'package:flutter/material.dart';
import 'package:qrty/core/theme/app_colors.dart';

class Fab extends StatelessWidget {
  const Fab({
    super.key,
    required this.onPressed,
    this.child = const Icon(Icons.arrow_forward),
  });
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: AppColors.primary, blurRadius: 30, spreadRadius: -5),
        ],
      ),
      child: FloatingActionButton(onPressed: onPressed, child: child),
    );
  }
}
