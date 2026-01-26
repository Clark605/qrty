import 'package:qrty/core/models/qr_form_data/qr_form_data_base.dart';
import 'package:qrty/core/utils/validators.dart';

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
