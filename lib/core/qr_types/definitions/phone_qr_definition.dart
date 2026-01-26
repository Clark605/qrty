import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/phone_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/qr_data_generators/phone_validator.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/phone_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Definition for Phone QR type
///
/// Handles phone numbers encoded in QR codes with tel: URI format.
class PhoneQrDefinition extends QrTypeDefinition<PhoneQrFormData> {
  @override
  QRCodeType get type => QRCodeType.phone;

  @override
  String get displayName => LocaleKeys.telephone.tr();

  @override
  String get icon => AppAssets.telephone;

  @override
  PhoneQrFormData createEmpty() => PhoneQrFormData.empty();

  @override
  PhoneQrFormData fromMap(Map<String, String> map) {
    return PhoneQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const PhoneQrFormScreen();
  }

  @override
  String generateQrData(PhoneQrFormData formData) {
    return PhoneValidator.formatForQr(formData.phone);
  }

  @override
  Map<String, String> validateData(PhoneQrFormData formData) {
    return formData.validate();
  }
}
