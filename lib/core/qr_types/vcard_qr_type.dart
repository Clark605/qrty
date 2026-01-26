import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/qr_generators.dart';
import 'package:qrty/core/utils/validators.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/contact_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

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

// ============================================================================
// Type Definition
// ============================================================================

/// Definition for vCard QR type
///
/// Handles contact information QR codes following vCard 3.0 standard
/// with name, company, job, phone, email, website, and address.
class VCardQrDefinition extends QrTypeDefinition<VCardQrFormData> {
  @override
  QRCodeType get type => QRCodeType.vcard;

  @override
  String get displayName => LocaleKeys.contact.tr();

  @override
  String get icon => AppAssets.contact;

  @override
  VCardQrFormData createEmpty() => VCardQrFormData.empty();

  @override
  VCardQrFormData fromMap(Map<String, String> map) {
    return VCardQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const ContactQrFormScreen();
  }

  @override
  String generateQrData(VCardQrFormData formData) {
    return VCardGenerator.generateContact(
      firstName: formData.firstName,
      lastName: formData.lastName,
      company: formData.company.isNotEmpty ? formData.company : null,
      job: formData.job.isNotEmpty ? formData.job : null,
      phone: formData.phone.isNotEmpty ? formData.phone : null,
      email: formData.email.isNotEmpty ? formData.email : null,
      website: formData.website.isNotEmpty ? formData.website : null,
      address: formData.address.isNotEmpty ? formData.address : null,
      city: formData.city.isNotEmpty ? formData.city : null,
      state: formData.state.isNotEmpty ? formData.state : null,
      zip: formData.zip.isNotEmpty ? formData.zip : null,
      country: formData.country.isNotEmpty ? formData.country : null,
    );
  }

  @override
  Map<String, String> validateData(VCardQrFormData formData) {
    return formData.validate();
  }
}
