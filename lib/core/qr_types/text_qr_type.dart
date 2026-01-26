import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/text_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

/// Form data model for text QR codes
///
/// Represents a simple text message to be encoded in a QR code.
class TextQrFormData extends QrFormDataBase {
  final String text;

  const TextQrFormData({required this.text});

  /// Create from map (deserialization)
  factory TextQrFormData.fromMap(Map<String, String> map) {
    return TextQrFormData(text: map['text'] ?? '');
  }

  /// Create empty instance
  factory TextQrFormData.empty() => const TextQrFormData(text: '');

  @override
  Map<String, String> toMap() => {'text': text};

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    if (text.trim().isEmpty) {
      errors['text'] = 'Text is required';
    }
    return errors;
  }

  /// Copy with new values
  TextQrFormData copyWith({String? text}) {
    return TextQrFormData(text: text ?? this.text);
  }
}

// ============================================================================
// Type Definition
// ============================================================================

/// Definition for Text QR type
///
/// Handles simple text messages encoded in QR codes.
class TextQrDefinition extends QrTypeDefinition<TextQrFormData> {
  @override
  QRCodeType get type => QRCodeType.text;

  @override
  String get displayName => LocaleKeys.text.tr();

  @override
  String get icon => AppAssets.text;

  @override
  TextQrFormData createEmpty() => TextQrFormData.empty();

  @override
  TextQrFormData fromMap(Map<String, String> map) {
    return TextQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const TextQrFormScreen();
  }

  @override
  String generateQrData(TextQrFormData formData) {
    return formData.text;
  }

  @override
  Map<String, String> validateData(TextQrFormData formData) {
    return formData.validate();
  }
}
