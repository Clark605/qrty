part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool isVibrateEnabled;
  final bool isBeepEnabled;
  final bool isLoading;

  const SettingsState({
    this.isVibrateEnabled = true,
    this.isBeepEnabled = true,
    this.isLoading = true,
  });

  SettingsState copyWith({
    bool? isVibrateEnabled,
    bool? isBeepEnabled,
    bool? isLoading,
  }) {
    return SettingsState(
      isVibrateEnabled: isVibrateEnabled ?? this.isVibrateEnabled,
      isBeepEnabled: isBeepEnabled ?? this.isBeepEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [isVibrateEnabled, isBeepEnabled, isLoading];
}
