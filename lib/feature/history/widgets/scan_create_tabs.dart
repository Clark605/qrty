import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/feature/history/cubit/history_cubit.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

class ScanCreateTabs extends StatelessWidget {
  final HistoryTab selectedTab;
  final Function(HistoryTab) onTabChanged;

  const ScanCreateTabs({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.wp(4),
        vertical: context.hp(1),
      ),
      decoration: BoxDecoration(
        color: const Color(0xff3C3C3C),
        borderRadius: BorderRadius.circular(context.wp(6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              context: context,
              title: LocaleKeys.scan.tr(),
              tab: HistoryTab.scan,
              isSelected: selectedTab == HistoryTab.scan,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              context: context,
              title: LocaleKeys.create.tr(),
              tab: HistoryTab.create,
              isSelected: selectedTab == HistoryTab.create,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required String title,
    required HistoryTab tab,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTabChanged(tab),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.hp(1.2),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(context.wp(6)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.secondary : AppColors.bodyGrey,
              fontSize: context.sp(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}