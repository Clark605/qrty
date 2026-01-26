import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/validators.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/email_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

/// Form data model for email QR codes
///
/// Represents an email with optional subject and body to be encoded in a QR code.
class EmailQrFormData extends QrFormDataBase {
  final String email;
  final String? subject;
  final String? body;

  const EmailQrFormData({required this.email, this.subject, this.body});

  /// Create from map (deserialization)
  factory EmailQrFormData.fromMap(Map<String, String> map) {
    return EmailQrFormData(
      email: map['email'] ?? '',
      subject: map['subject'],
      body: map['body'],
    );
  }

  /// Create empty instance
  factory EmailQrFormData.empty() => const EmailQrFormData(email: '');

  @override
  Map<String, String> toMap() {
    final map = <String, String>{'email': email};
    if (subject?.isNotEmpty == true) map['subject'] = subject!;
    if (body?.isNotEmpty == true) map['body'] = body!;
    return map;
  }

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!EmailValidator.isValid(trimmedEmail)) {
      errors['email'] = 'Please enter a valid email address';
    }

    return errors;
  }

  /// Copy with new values
  EmailQrFormData copyWith({String? email, String? subject, String? body}) {
    return EmailQrFormData(
      email: email ?? this.email,
      subject: subject ?? this.subject,
      body: body ?? this.body,
    );
  }
}

// ============================================================================
// Type Definition
// ============================================================================

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
