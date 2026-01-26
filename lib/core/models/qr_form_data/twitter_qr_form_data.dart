import 'package:qrty/core/models/qr_form_data/qr_form_data_base.dart';

/// Form data model for Twitter QR codes
///
/// Represents a Twitter handle to be encoded as a profile URL.
class TwitterQrFormData extends QrFormDataBase {
  final String handle;

  const TwitterQrFormData({required this.handle});

  /// Create from map (deserialization)
  factory TwitterQrFormData.fromMap(Map<String, String> map) {
    return TwitterQrFormData(handle: map['handle'] ?? '');
  }

  /// Create empty instance
  factory TwitterQrFormData.empty() => const TwitterQrFormData(handle: '');

  @override
  Map<String, String> toMap() => {'handle': handle};

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    final trimmedHandle = handle.trim();

    if (trimmedHandle.isEmpty) {
      errors['handle'] = 'Handle is required';
    } else {
      // Remove @ if present for validation
      final cleanHandle = trimmedHandle.replaceFirst('@', '');

      // Twitter username: alphanumeric and underscore only, 1-15 chars
      final handleRegex = RegExp(r'^[a-zA-Z0-9_]{1,15}$');
      if (!handleRegex.hasMatch(cleanHandle)) {
        errors['handle'] = 'Please enter a valid Twitter handle';
      }
    }

    return errors;
  }

  /// Copy with new values
  TwitterQrFormData copyWith({String? handle}) {
    return TwitterQrFormData(handle: handle ?? this.handle);
  }
}
