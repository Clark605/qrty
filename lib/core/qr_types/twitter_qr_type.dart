import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/twitter_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

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

// ============================================================================
// Type Definition
// ============================================================================

/// Definition for Twitter QR type
///
/// Handles Twitter handles, converts to Twitter profile URL.
class TwitterQrDefinition extends QrTypeDefinition<TwitterQrFormData> {
  @override
  QRCodeType get type => QRCodeType.twitter;

  @override
  String get displayName => LocaleKeys.twitter.tr();

  @override
  String get icon => AppAssets.twitter;

  @override
  TwitterQrFormData createEmpty() => TwitterQrFormData.empty();

  @override
  TwitterQrFormData fromMap(Map<String, String> map) {
    return TwitterQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const TwitterQrFormScreen();
  }

  @override
  String generateQrData(TwitterQrFormData formData) {
    // Remove @ if present and create Twitter URL
    final cleanHandle = formData.handle.replaceFirst('@', '');
    return 'https://twitter.com/$cleanHandle';
  }

  @override
  Map<String, String> validateData(TwitterQrFormData formData) {
    return formData.validate();
  }
}
