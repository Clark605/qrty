import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';

class ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(context.hp(2)),
            decoration: BoxDecoration(
              color: onTap == null
                  ? AppColors.primary.withOpacity(0.5)
                  : AppColors.primary,
              borderRadius: BorderRadius.circular(context.wp(3)),
            ),
            child: isLoading
                ? SizedBox(
                    width: context.wp(8),
                    height: context.wp(8),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.secondary,
                      ),
                    ),
                  )
                : SvgPicture.asset(
                    icon,
                    width: context.wp(8),
                    height: context.wp(8),
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondary,
                      BlendMode.srcIn,
                    ),
                  ),
          ),
          SizedBox(height: context.hp(1)),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white,
              fontSize: context.sp(14),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
