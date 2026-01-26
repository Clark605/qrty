import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/validators.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/sms_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

/// Form data model for SMS/WhatsApp QR codes
///
/// Represents a phone number with optional pre-filled message.
class SmsQrFormData extends QrFormDataBase {
  final String phone;
  final String? message;

  const SmsQrFormData({required this.phone, this.message});

  /// Create from map (deserialization)
  factory SmsQrFormData.fromMap(Map<String, String> map) {
    return SmsQrFormData(phone: map['phone'] ?? '', message: map['message']);
  }

  /// Create empty instance
  factory SmsQrFormData.empty() => const SmsQrFormData(phone: '');

  @override
  Map<String, String> toMap() {
    final map = <String, String>{'phone': phone};
    if (message?.isNotEmpty == true) map['message'] = message!;
    return map;
  }

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    final trimmedPhone = phone.trim();

    if (trimmedPhone.isEmpty) {
      errors['phone'] = 'Phone number is required';
    } else if (!PhoneValidator.isValid(trimmedPhone)) {
      errors['phone'] = 'Please enter a valid phone number';
    }

    return errors;
  }

  /// Copy with new values
  SmsQrFormData copyWith({String? phone, String? message}) {
    return SmsQrFormData(
      phone: phone ?? this.phone,
      message: message ?? this.message,
    );
  }
}

// ============================================================================
// Type Definition
// ============================================================================

/// Definition for SMS/WhatsApp QR type
///
/// Handles SMS with optional message, generates sms: URI format.
class SmsQrDefinition extends QrTypeDefinition<SmsQrFormData> {
  @override
  QRCodeType get type => QRCodeType.sms;

  @override
  String get displayName => LocaleKeys.whatsapp.tr();

  @override
  String get icon => AppAssets.telephone;

  @override
  SmsQrFormData createEmpty() => SmsQrFormData.empty();

  @override
  SmsQrFormData fromMap(Map<String, String> map) {
    return SmsQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const SmsQrFormScreen();
  }

  @override
  String generateQrData(SmsQrFormData formData) {
    return PhoneValidator.formatForSms(
      formData.phone,
      message: formData.message,
    );
  }

  @override
  Map<String, String> validateData(SmsQrFormData formData) {
    return formData.validate();
  }
}
