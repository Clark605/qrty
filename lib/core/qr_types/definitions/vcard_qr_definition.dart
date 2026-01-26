import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/vcard_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/qr_data_generators/vcard_generator.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/contact_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

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
