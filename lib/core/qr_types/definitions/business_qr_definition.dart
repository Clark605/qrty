import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/business_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/qr_generators.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/business_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

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
