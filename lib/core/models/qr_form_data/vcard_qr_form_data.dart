import 'package:qrty/core/models/qr_form_data/qr_form_data_base.dart';
import 'package:qrty/core/utils/qr_data_generators/email_validator.dart';

/// Form data model for vCard (contact) QR codes
///
/// Represents contact information following vCard 3.0 standard with name,
/// company, job, phone, email, website, and address fields.
class VCardQrFormData extends QrFormDataBase {
  final String firstName;
  final String lastName;
  final String company;
  final String job;
  final String phone;
  final String email;
  final String website;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String country;

  const VCardQrFormData({
    required this.firstName,
    required this.lastName,
    this.company = '',
    this.job = '',
    this.phone = '',
    this.email = '',
    this.website = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.country = '',
  });

  /// Create from map (deserialization)
  factory VCardQrFormData.fromMap(Map<String, String> map) {
    return VCardQrFormData(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      company: map['company'] ?? '',
      job: map['job'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
      country: map['country'] ?? '',
    );
  }

  /// Create empty instance
  factory VCardQrFormData.empty() =>
      const VCardQrFormData(firstName: '', lastName: '');

  @override
  Map<String, String> toMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'company': company,
    'job': job,
    'phone': phone,
    'email': email,
    'website': website,
    'address': address,
    'city': city,
    'state': state,
    'zip': zip,
    'country': country,
  };

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};

    // At least first name or last name is required
    if (firstName.trim().isEmpty && lastName.trim().isEmpty) {
      errors['firstName'] = 'First name or last name is required';
      errors['lastName'] = 'First name or last name is required';
    }

    // Validate email if provided
    if (email.trim().isNotEmpty && !EmailValidator.isValid(email)) {
      errors['email'] = 'Invalid email format';
    }

    return errors;
  }

  /// Copy with new values
  VCardQrFormData copyWith({
    String? firstName,
    String? lastName,
    String? company,
    String? job,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? country,
  }) {
    return VCardQrFormData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      job: job ?? this.job,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      country: country ?? this.country,
    );
  }
}
