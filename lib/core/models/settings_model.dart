class SettingsModel {
  final bool isVibrateEnabled;
  final bool isBeepEnabled;

  const SettingsModel({
    required this.isVibrateEnabled,
    required this.isBeepEnabled,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      isVibrateEnabled: json['isVibrateEnabled'] as bool? ?? true,
      isBeepEnabled: json['isBeepEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isVibrateEnabled': isVibrateEnabled,
      'isBeepEnabled': isBeepEnabled,
    };
  }

  SettingsModel copyWith({bool? isVibrateEnabled, bool? isBeepEnabled}) {
    return SettingsModel(
      isVibrateEnabled: isVibrateEnabled ?? this.isVibrateEnabled,
      isBeepEnabled: isBeepEnabled ?? this.isBeepEnabled,
    );
  }
}
