import 'package:qrty/core/models/qr_form_data/qr_form_data_base.dart';
import 'package:qrty/core/utils/validators.dart';

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
