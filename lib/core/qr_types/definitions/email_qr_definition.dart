import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/email_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/validators.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/email_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Definition for Email QR type
///
/// Handles email addresses with optional subject and body.
/// Generates mailto: URIs for QR codes.
class EmailQrDefinition extends QrTypeDefinition<EmailQrFormData> {
  @override
  QRCodeType get type => QRCodeType.email;

  @override
  String get displayName => LocaleKeys.email.tr();

  @override
  String get icon => AppAssets.email;

  @override
  EmailQrFormData createEmpty() => EmailQrFormData.empty();

  @override
  EmailQrFormData fromMap(Map<String, String> map) {
    return EmailQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const EmailQrFormScreen();
  }

  @override
  String generateQrData(EmailQrFormData formData) {
    // Generate mailto: URI with optional subject and body
    return EmailValidator.formatForQr(
      formData.email,
      subject: formData.subject,
      body: formData.body,
    );
  }

  @override
  Map<String, String> validateData(EmailQrFormData formData) {
    return formData.validate();
  }
}
