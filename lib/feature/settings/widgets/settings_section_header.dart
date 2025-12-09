import 'package:flutter/material.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.hp(2),
        bottom: context.hp(1.5),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: context.sp(20),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
