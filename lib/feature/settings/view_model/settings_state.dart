part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool isVibrateEnabled;
  final bool isBeepEnabled;
  final bool isLoading;
  final Locale locale;

  const SettingsState({
    this.isVibrateEnabled = true,
    this.isBeepEnabled = true,
    this.isLoading = true,
    this.locale = AppConstants.englishLocale,
  });

  SettingsState copyWith({
    bool? isVibrateEnabled,
    bool? isBeepEnabled,
    bool? isLoading,
    Locale? locale,
  }) {
    return SettingsState(
      isVibrateEnabled: isVibrateEnabled ?? this.isVibrateEnabled,
      isBeepEnabled: isBeepEnabled ?? this.isBeepEnabled,
      isLoading: isLoading ?? this.isLoading,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [
    isVibrateEnabled,
    isBeepEnabled,
    isLoading,
    locale,
  ];
}
