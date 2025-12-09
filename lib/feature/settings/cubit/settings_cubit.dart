import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/services/settings_service.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    loadSettings();
  }

  /// Load settings from SharedPreferences
  Future<void> loadSettings() async {
    try {
      final settings = await SettingsService.instance.getSettings();
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
    await SettingsService.instance.saveVibrate(newValue);
  }

  /// Toggle beep setting
  Future<void> toggleBeep() async {
    final newValue = !state.isBeepEnabled;
    emit(state.copyWith(isBeepEnabled: newValue));
    await SettingsService.instance.saveBeep(newValue);
  }
}
