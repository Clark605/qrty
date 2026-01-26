import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/validators.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/phone_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

/// Form data model for phone QR codes
///
/// Represents a phone number to be encoded in a QR code.
class PhoneQrFormData extends QrFormDataBase {
  final String phone;

  const PhoneQrFormData({required this.phone});

  /// Create from map (deserialization)
  factory PhoneQrFormData.fromMap(Map<String, String> map) {
    return PhoneQrFormData(phone: map['phone'] ?? '');
  }

  /// Create empty instance
  factory PhoneQrFormData.empty() => const PhoneQrFormData(phone: '');

  @override
  Map<String, String> toMap() => {'phone': phone};

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
  PhoneQrFormData copyWith({String? phone}) {
    return PhoneQrFormData(phone: phone ?? this.phone);
  }
}

// ============================================================================
// Type Definition
// ============================================================================

/// Definition for Phone QR type
///
/// Handles phone numbers encoded in QR codes with tel: URI format.
class PhoneQrDefinition extends QrTypeDefinition<PhoneQrFormData> {
  @override
  QRCodeType get type => QRCodeType.phone;

  @override
  String get displayName => LocaleKeys.telephone.tr();

  @override
  String get icon => AppAssets.telephone;

  @override
  PhoneQrFormData createEmpty() => PhoneQrFormData.empty();

  @override
  PhoneQrFormData fromMap(Map<String, String> map) {
    return PhoneQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const PhoneQrFormScreen();
  }

  @override
  String generateQrData(PhoneQrFormData formData) {
    return PhoneValidator.formatForQr(formData.phone);
  }

  @override
  Map<String, String> validateData(PhoneQrFormData formData) {
    return formData.validate();
  }
}
