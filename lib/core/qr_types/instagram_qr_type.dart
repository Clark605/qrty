import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/instagram_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

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

// ============================================================================
// Type Definition
// ============================================================================

/// Definition for Instagram QR type
///
/// Handles Instagram handles, converts to Instagram profile URL.
class InstagramQrDefinition extends QrTypeDefinition<InstagramQrFormData> {
  @override
  QRCodeType get type => QRCodeType.instagram;

  @override
  String get displayName => LocaleKeys.instagram.tr();

  @override
  String get icon => AppAssets.instagram;

  @override
  InstagramQrFormData createEmpty() => InstagramQrFormData.empty();

  @override
  InstagramQrFormData fromMap(Map<String, String> map) {
    return InstagramQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const InstagramQrFormScreen();
  }

  @override
  String generateQrData(InstagramQrFormData formData) {
    // Remove @ if present and create Instagram URL
    final cleanHandle = formData.handle.replaceFirst('@', '');
    return 'https://instagram.com/$cleanHandle';
  }

  @override
  Map<String, String> validateData(InstagramQrFormData formData) {
    return formData.validate();
  }
}
