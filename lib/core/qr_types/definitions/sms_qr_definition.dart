import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/sms_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/validators.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/sms_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

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
