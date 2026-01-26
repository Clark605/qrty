import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/validators.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/url_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

/// Form data model for URL QR codes
///
/// Represents a website URL to be encoded in a QR code.
class UrlQrFormData extends QrFormDataBase {
  final String url;

  const UrlQrFormData({required this.url});

  /// Create from map (deserialization)
  factory UrlQrFormData.fromMap(Map<String, String> map) {
    return UrlQrFormData(url: map['url'] ?? '');
  }

  /// Create empty instance
  factory UrlQrFormData.empty() => const UrlQrFormData(url: '');

  @override
  Map<String, String> toMap() => {'url': url};

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    final trimmedUrl = url.trim();

    if (trimmedUrl.isEmpty) {
      errors['url'] = 'URL is required';
    } else if (!UrlValidator.isValid(trimmedUrl)) {
      errors['url'] = 'Please enter a valid URL';
    }

    return errors;
  }

  /// Copy with new values
  UrlQrFormData copyWith({String? url}) {
    return UrlQrFormData(url: url ?? this.url);
  }
}

// ============================================================================
// Type Definition
// ============================================================================

/// Definition for URL QR type
///
/// Handles website URLs encoded in QR codes.
/// Automatically adds https:// prefix if missing.
class UrlQrDefinition extends QrTypeDefinition<UrlQrFormData> {
  @override
  QRCodeType get type => QRCodeType.url;

  @override
  String get displayName => LocaleKeys.website.tr();

  @override
  String get icon => AppAssets.website;

  @override
  UrlQrFormData createEmpty() => UrlQrFormData.empty();

  @override
  UrlQrFormData fromMap(Map<String, String> map) {
    return UrlQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const UrlQrFormScreen();
  }

  @override
  String generateQrData(UrlQrFormData formData) {
    // Format URL (adds https:// if needed)
    return UrlValidator.format(formData.url);
  }

  @override
  Map<String, String> validateData(UrlQrFormData formData) {
    return formData.validate();
  }
}
