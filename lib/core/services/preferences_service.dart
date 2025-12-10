import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app preferences using SharedPreferences
class PreferencesService {
  static const String _firstLaunchKey = 'first_launch';

  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception(
        'PreferencesService not initialized. Call initialize() first.',
      );
    }
    return _prefs!;
  }

  /// Check if this is the first launch of the app
  static bool get isFirstLaunch {
    return _instance.getBool(_firstLaunchKey) ?? true;
  }

  /// Mark that the app has been launched
  static Future<void> markFirstLaunchCompleted() async {
    log('PreferencesService: Marking first launch as completed');
    await _instance.setBool(_firstLaunchKey, false);
  }

  /// Clear all preferences (useful for testing or reset functionality)
  static Future<void> clearAll() async {
    await _instance.clear();
  }

  /// Clear specific preference by key
  static Future<void> clearKey(String key) async {
    await _instance.remove(key);
  }

  /// Check if a key exists in preferences
  static bool containsKey(String key) {
    return _instance.containsKey(key);
  }
}
