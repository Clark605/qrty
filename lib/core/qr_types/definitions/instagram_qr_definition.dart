import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/instagram_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/instagram_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Definition for Instagram QR type
///
/// Handles Instagram handles, converts to Instagram profile URL.
class InstagramQrDefinition extends QrTypeDefinition<InstagramQrFormData> {
  @override
  QRCodeType get type => QRCodeType.instagram;

  @override
  String get displayName => LocaleKeys.instagram.tr();

  @override
  String get icon => AppAssets.instagram;

  @override
  InstagramQrFormData createEmpty() => InstagramQrFormData.empty();

  @override
  InstagramQrFormData fromMap(Map<String, String> map) {
    return InstagramQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const InstagramQrFormScreen();
  }

  @override
  String generateQrData(InstagramQrFormData formData) {
    // Remove @ if present and create Instagram URL
    final cleanHandle = formData.handle.replaceFirst('@', '');
    return 'https://instagram.com/$cleanHandle';
  }

  @override
  Map<String, String> validateData(InstagramQrFormData formData) {
    return formData.validate();
  }
}
