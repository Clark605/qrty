import 'package:qrty/core/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyVibrateEnabled = 'vibrate_enabled';
  static const String _keyBeepEnabled = 'beep_enabled';

  /// Get current settings from SharedPreferences
  Future<SettingsModel> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isVibrateEnabled = prefs.getBool(_keyVibrateEnabled) ?? true;
      final isBeepEnabled = prefs.getBool(_keyBeepEnabled) ?? true;

      return SettingsModel(
        isVibrateEnabled: isVibrateEnabled,
        isBeepEnabled: isBeepEnabled,
      );
    } catch (e) {
      // Return default settings on error
      return const SettingsModel(isVibrateEnabled: true, isBeepEnabled: true);
    }
  }

  /// Save vibrate preference
  Future<void> saveVibrate(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyVibrateEnabled, enabled);
    } catch (e) {
      // Log error or handle silently
    }
  }

  /// Save beep preference
  Future<void> saveBeep(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyBeepEnabled, enabled);
    } catch (e) {
      // Log error or handle silently
    }
  }
}
