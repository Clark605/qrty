import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/common/widgets/app_background.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/extensions/navigator_extensions.dart';
import 'package:qrty/core/routes/routes.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/feature/history/cubit/history_cubit.dart';
import 'package:qrty/feature/history/widgets/empty_history_state.dart';
import 'package:qrty/feature/history/widgets/history_item.dart';
import 'package:qrty/feature/history/widgets/scan_create_tabs.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late HistoryCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<HistoryCubit>();
    // Load history when screen initializes
    cubit.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Text(
            LocaleKeys.history.tr(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            // Clear history button
            BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                // Only show clear button if current tab has history
                if (state.currentHistory.isEmpty)
                  return const SizedBox.shrink();

                return IconButton(
                  onPressed: () =>
                      _showClearHistoryDialog(context, state.selectedTab),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.primary,
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            return Column(
              children: [
                // Tab Switcher
                ScanCreateTabs(
                  selectedTab: state.selectedTab,
                  onTabChanged: (tab) => cubit.switchTab(tab),
                ),

                // Content Area
                Expanded(child: _buildContent(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(HistoryState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.currentHistory.isEmpty) {
      return EmptyHistoryState(currentTab: state.selectedTab);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: context.hp(1)),
      itemCount: state.currentHistory.length,
      itemBuilder: (context, index) {
        final historyItem = state.currentHistory[index];
        return HistoryItem(
          historyItem: historyItem,
          onDelete: () => _showDeleteDialog(context, historyItem.id),
          onTap: () => _navigateToQrView(historyItem),
        );
      },
    );
  }

  void _navigateToQrView(historyItem) {
    context.pushNamed(
      Routes.qrView,
      arguments: {
        'data': historyItem.data,
        'timestamp': historyItem.timestamp,
        'source': historyItem.source,
        'type': historyItem.type,
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int itemId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.secondary,
        title: Text(
          LocaleKeys.delete_item.tr(),
          style: const TextStyle(color: AppColors.white),
        ),
        content: Text(
          LocaleKeys.delete_item_desc.tr(),
          style: TextStyle(color: AppColors.bodyGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              LocaleKeys.cancel.tr(),
              style: const TextStyle(color: AppColors.bodyGrey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.deleteHistoryItem(itemId);
            },
            child: Text(
              LocaleKeys.delete.tr(),
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, HistoryTab tab) {
    final isScannTab = tab == HistoryTab.scan;
    final title = isScannTab
        ? LocaleKeys.clear_scan_history.tr()
        : LocaleKeys.clear_create_history.tr();
    final description = isScannTab
        ? LocaleKeys.clear_scan_history_desc.tr()
        : LocaleKeys.clear_create_history_desc.tr();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.secondary,
        title: Text(title, style: const TextStyle(color: AppColors.white)),
        content: Text(description, style: TextStyle(color: AppColors.bodyGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              LocaleKeys.cancel.tr(),
              style: const TextStyle(color: AppColors.bodyGrey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (isScannTab) {
                cubit.clearScanHistory();
              } else {
                cubit.clearCreateHistory();
              }
            },
            child: Text(
              LocaleKeys.clear.tr(),
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
