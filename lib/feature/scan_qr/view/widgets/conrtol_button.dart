import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';

class ControlButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final bool isActive;

  const ControlButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.wp(3)),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : AppColors.secondary.withOpacity(0.7),
          borderRadius: BorderRadius.circular(context.wp(6)),
        ),
        child: SvgPicture.asset(
          icon,
          width: context.wp(6),
          height: context.wp(6),
          colorFilter: ColorFilter.mode(
            isActive ? AppColors.secondary : AppColors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
