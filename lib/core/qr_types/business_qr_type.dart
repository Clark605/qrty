import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/qr_generators.dart';
import 'package:qrty/core/utils/validators.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/business_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

/// Form data model for Business Card QR codes
///
/// Represents business information following vCard 3.0 standard with company,
/// industry, phone, email, website, and address fields.
class BusinessQrFormData extends QrFormDataBase {
  final String company;
  final String industry;
  final String phone;
  final String email;
  final String website;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String country;

  const BusinessQrFormData({
    required this.company,
    this.industry = '',
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
  factory BusinessQrFormData.fromMap(Map<String, String> map) {
    return BusinessQrFormData(
      company: map['company'] ?? '',
      industry: map['industry'] ?? '',
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
  factory BusinessQrFormData.empty() => const BusinessQrFormData(company: '');

  @override
  Map<String, String> toMap() => {
    'company': company,
    'industry': industry,
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

    // Company name is required
    if (company.trim().isEmpty) {
      errors['company'] = 'Company name is required';
    }

    // Validate email if provided
    if (email.trim().isNotEmpty && !EmailValidator.isValid(email)) {
      errors['email'] = 'Invalid email format';
    }

    return errors;
  }

  /// Copy with new values
  BusinessQrFormData copyWith({
    String? company,
    String? industry,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? country,
  }) {
    return BusinessQrFormData(
      company: company ?? this.company,
      industry: industry ?? this.industry,
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

/// Definition for Business Card QR type
///
/// Handles business information QR codes following vCard 3.0 standard
/// with company, industry, phone, email, website, and address.
class BusinessQrDefinition extends QrTypeDefinition<BusinessQrFormData> {
  @override
  QRCodeType get type => QRCodeType.business;

  @override
  String get displayName => LocaleKeys.business.tr();

  @override
  String get icon => AppAssets.business;

  @override
  BusinessQrFormData createEmpty() => BusinessQrFormData.empty();

  @override
  BusinessQrFormData fromMap(Map<String, String> map) {
    return BusinessQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const BusinessQrFormScreen();
  }

  @override
  String generateQrData(BusinessQrFormData formData) {
    return VCardGenerator.generateBusiness(
      company: formData.company,
      industry: formData.industry.isNotEmpty ? formData.industry : null,
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
  Map<String, String> validateData(BusinessQrFormData formData) {
    return formData.validate();
  }
}
