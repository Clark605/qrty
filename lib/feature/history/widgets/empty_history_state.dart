import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/feature/history/cubit/history_cubit.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

class EmptyHistoryState extends StatelessWidget {
  final HistoryTab currentTab;

  const EmptyHistoryState({
    super.key,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.wp(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty State Icon
            Container(
              padding: EdgeInsets.all(context.wp(8)),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                _getEmptyStateIcon(),
                width: context.wp(16),
                height: context.wp(16),
                colorFilter: ColorFilter.mode(
                  AppColors.primary.withOpacity(0.6),
                  BlendMode.srcIn,
                ),
              ),
            ),
            
            SizedBox(height: context.hp(3)),
            
            // Empty State Title
            Text(
              _getEmptyStateTitle(),
              style: TextStyle(
                color: AppColors.white,
                fontSize: context.sp(20),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: context.hp(1)),
            
            // Empty State Description
            Text(
              _getEmptyStateDescription(),
              style: TextStyle(
                color: AppColors.bodyGrey,
                fontSize: context.sp(14),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getEmptyStateIcon() {
    switch (currentTab) {
      case HistoryTab.scan:
        return AppAssets.qr; // Use QR scan icon
      case HistoryTab.create:
        return AppAssets.qrAppBar; // Use QR generate icon
    }
  }

  String _getEmptyStateTitle() {
    switch (currentTab) {
      case HistoryTab.scan:
        return LocaleKeys.no_scan_history.tr();
      case HistoryTab.create:
        return LocaleKeys.no_create_history.tr();
    }
  }

  String _getEmptyStateDescription() {
    switch (currentTab) {
      case HistoryTab.scan:
        return LocaleKeys.no_scan_history_desc.tr();
      case HistoryTab.create:
        return LocaleKeys.no_create_history_desc.tr();
    }
  }
}