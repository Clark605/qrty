import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/constants/app_constants.dart';
import 'package:qrty/core/constants/app_fonts.dart';
import 'package:qrty/core/dialogs/app_dialogs.dart';
import 'package:qrty/feature/settings/data/settings_service.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsService settingsService;
  SettingsCubit(this.settingsService) : super(const SettingsState()) {
    loadSettings();
  }

  /// Load settings from SharedPreferences
  Future<void> loadSettings() async {
    try {
      final settings = await settingsService.getSettings();
      emit(
        state.copyWith(
          isVibrateEnabled: settings.isVibrateEnabled,
          isBeepEnabled: settings.isBeepEnabled,
          isLoading: false,
        ),
      );
    } catch (e) {
      // Keep default state on error
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Toggle vibrate setting
  Future<void> toggleVibrate() async {
    final newValue = !state.isVibrateEnabled;
    emit(state.copyWith(isVibrateEnabled: newValue));
    await settingsService.saveVibrate(newValue);
  }

  /// Toggle beep setting
  Future<void> toggleBeep() async {
    final newValue = !state.isBeepEnabled;
    emit(state.copyWith(isBeepEnabled: newValue));
    await settingsService.saveBeep(newValue);
  }

  Future<void> showLanguageSelectionDialog(BuildContext context) async {
    final selectedLocale = await AppDialogs.selectionDialog<Locale>(
      context: context,
      title: Text(
        LocaleKeys.language.tr(),
        style: TextStyle(color: AppColors.white, fontFamily: AppFonts.itim),
      ),
      options: AppConstants.supportedLocales.map((locale) {
        return SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, locale);
          },
          child: Text(
            locale.languageCode == 'en' ? 'English' : 'العربية',
            style: TextStyle(color: AppColors.white),
          ),
        );
      }).toList(),
    );
    context.setLocale(selectedLocale ?? state.locale);
    emit(state.copyWith(locale: selectedLocale ?? state.locale));
    // Here you can also save the locale to persistent storage if needed
  }
}
