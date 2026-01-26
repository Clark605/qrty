import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/location_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/location_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Definition for Location QR type
///
/// Handles location/address text encoded in QR codes.
/// Future enhancement: Support geo: URI format for coordinates.
class LocationQrDefinition extends QrTypeDefinition<LocationQrFormData> {
  @override
  QRCodeType get type => QRCodeType.location;

  @override
  String get displayName => LocaleKeys.location.tr();

  @override
  String get icon => AppAssets.location;

  @override
  LocationQrFormData createEmpty() => LocationQrFormData.empty();

  @override
  LocationQrFormData fromMap(Map<String, String> map) {
    return LocationQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const LocationQrFormScreen();
  }

  @override
  String generateQrData(LocationQrFormData formData) {
    // For now, return as plain text
    // TODO: Could be enhanced to support geo: format
    return formData.location;
  }

  @override
  Map<String, String> validateData(LocationQrFormData formData) {
    return formData.validate();
  }
}
