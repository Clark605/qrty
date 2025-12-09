import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';

class SettingsNavigationItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsNavigationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.wp(2)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.hp(1.5)),
        child: Row(
          children: [
            // Icon
            Container(
              width: context.wp(10),
              height: context.wp(10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(context.wp(2)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: context.wp(6),
                  height: context.wp(6),
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: context.wp(4)),
            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: context.hp(0.3)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.bodyGrey,
                      fontSize: context.sp(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
