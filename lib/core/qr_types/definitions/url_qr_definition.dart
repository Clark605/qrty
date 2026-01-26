import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/url_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/qr_data_generators/url_validator.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/url_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Definition for URL QR type
///
/// Handles website URLs encoded in QR codes.
/// Automatically adds https:// prefix if missing.
class UrlQrDefinition extends QrTypeDefinition<UrlQrFormData> {
  @override
  QRCodeType get type => QRCodeType.url;

  @override
  String get displayName => LocaleKeys.website.tr();

  @override
  String get icon => AppAssets.website;

  @override
  UrlQrFormData createEmpty() => UrlQrFormData.empty();

  @override
  UrlQrFormData fromMap(Map<String, String> map) {
    return UrlQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const UrlQrFormScreen();
  }

  @override
  String generateQrData(UrlQrFormData formData) {
    // Format URL (adds https:// if needed)
    return UrlValidator.format(formData.url);
  }

  @override
  Map<String, String> validateData(UrlQrFormData formData) {
    return formData.validate();
  }
}
