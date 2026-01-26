import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/twitter_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/twitter_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Definition for Twitter QR type
///
/// Handles Twitter handles, converts to Twitter profile URL.
class TwitterQrDefinition extends QrTypeDefinition<TwitterQrFormData> {
  @override
  QRCodeType get type => QRCodeType.twitter;

  @override
  String get displayName => LocaleKeys.twitter.tr();

  @override
  String get icon => AppAssets.twitter;

  @override
  TwitterQrFormData createEmpty() => TwitterQrFormData.empty();

  @override
  TwitterQrFormData fromMap(Map<String, String> map) {
    return TwitterQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const TwitterQrFormScreen();
  }

  @override
  String generateQrData(TwitterQrFormData formData) {
    // Remove @ if present and create Twitter URL
    final cleanHandle = formData.handle.replaceFirst('@', '');
    return 'https://twitter.com/$cleanHandle';
  }

  @override
  Map<String, String> validateData(TwitterQrFormData formData) {
    return formData.validate();
  }
}
