import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/common/widgets/app_background.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/feature/settings/view_model/settings_cubit.dart';
import 'package:qrty/feature/settings/view/widgets/settings_navigation_item.dart';
import 'package:qrty/feature/settings/view/widgets/settings_section_header.dart';
import 'package:qrty/feature/settings/view/widgets/settings_toggle_item.dart';
import 'package:qrty/l10n/locale_keys.g.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            LocaleKeys.settings.tr(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final cubit = context.read<SettingsCubit>();

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.wp(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Settings Section
                  SectionHeader(title: LocaleKeys.settings.tr()),
                  SettingsToggleItem(
                    icon: AppAssets.vibrate,
                    title: LocaleKeys.vibrate.tr(),
                    subtitle: LocaleKeys.vibration_when_scan_is_done.tr(),
                    value: state.isVibrateEnabled,
                    onChanged: (_) => cubit.toggleVibrate(),
                  ),
                  MyDivider(),
                  SettingsToggleItem(
                    icon: AppAssets.notification,
                    title: LocaleKeys.beep.tr(),
                    subtitle: LocaleKeys.beep_when_scan_is_done.tr(),
                    value: state.isBeepEnabled,
                    onChanged: (_) => cubit.toggleBeep(),
                  ),
                  MyDivider(),
                  SettingsToggleItem(
                    icon: AppAssets.text,
                    title: LocaleKeys.language.tr(),
                    subtitle: LocaleKeys.choose_your_preferred_language.tr(),
                    onTap: () => cubit.showLanguageSelectionDialog(context),
                  ),

                  SizedBox(height: context.hp(2)),

                  // Support Section
                  SectionHeader(title: LocaleKeys.support.tr()),
                  NavigationItem(
                    icon: AppAssets.rate,
                    title: LocaleKeys.rate_us.tr(),
                    subtitle: LocaleKeys.your_best_reward_to_us.tr(),
                    onTap: () => _openStoreUrl(context),
                  ),
                  MyDivider(),
                  NavigationItem(
                    icon: AppAssets.privacy,
                    title: LocaleKeys.privacy_policy.tr(),
                    subtitle: LocaleKeys.follow_our_policies_that_benefits_you
                        .tr(),
                    onTap: () => _showPrivacyPolicyDialog(context),
                  ),
                  MyDivider(),
                  NavigationItem(
                    icon: AppAssets.share,
                    title: LocaleKeys.share.tr(),
                    subtitle: LocaleKeys.share_app_with_others.tr(),
                    onTap: () => _shareApp(),
                  ),

                  SizedBox(height: context.hp(4)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Open store URL for rating
  Future<void> _openStoreUrl(BuildContext context) async {
    final String url;
    if (Platform.isAndroid) {
      // Replace with actual package name
      url = 'https://play.google.com/store/apps/details?id=com.example.qrty';
    } else if (Platform.isIOS) {
      // Replace with actual app ID
      url = 'https://apps.apple.com/app/id123456789';
    } else {
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open store')));
      }
    }
  }

  /// Show privacy policy dialog (placeholder)
  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondary,
        title: Text(
          LocaleKeys.privacy_policy.tr(),
          style: const TextStyle(color: AppColors.white),
        ),
        content: Text(
          'Privacy policy content will be displayed here.',
          style: TextStyle(color: AppColors.bodyGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  /// Share app
  void _shareApp() {
    Share.share(
      'Check out QRty - The best QR code scanner app!',
      subject: 'QRty App',
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.primary.withOpacity(0.3),
      indent: context.wp(14),
      thickness: 1,
    );
  }
}
