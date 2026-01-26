import 'package:qrty/core/models/qr_form_data/qr_form_data_base.dart';
import 'package:qrty/core/utils/qr_data_generators/email_validator.dart';

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
