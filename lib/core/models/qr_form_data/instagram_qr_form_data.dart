import 'package:qrty/core/models/qr_form_data/qr_form_data_base.dart';

/// Form data model for Instagram QR codes
///
/// Represents an Instagram handle to be encoded as a profile URL.
class InstagramQrFormData extends QrFormDataBase {
  final String handle;

  const InstagramQrFormData({required this.handle});

  /// Create from map (deserialization)
  factory InstagramQrFormData.fromMap(Map<String, String> map) {
    return InstagramQrFormData(handle: map['handle'] ?? '');
  }

  /// Create empty instance
  factory InstagramQrFormData.empty() => const InstagramQrFormData(handle: '');

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

      // Instagram username: alphanumeric, underscore, and dot, 1-30 chars
      final handleRegex = RegExp(r'^[a-zA-Z0-9_.]{1,30}$');
      if (!handleRegex.hasMatch(cleanHandle)) {
        errors['handle'] = 'Please enter a valid Instagram handle';
      }
    }

    return errors;
  }

  /// Copy with new values
  InstagramQrFormData copyWith({String? handle}) {
    return InstagramQrFormData(handle: handle ?? this.handle);
  }
}
