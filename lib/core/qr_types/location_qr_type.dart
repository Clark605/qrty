import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/location_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

/// Form data model for location QR codes
///
/// Represents a location/address to be encoded in a QR code.
class LocationQrFormData extends QrFormDataBase {
  final String location;

  const LocationQrFormData({required this.location});

  /// Create from map (deserialization)
  factory LocationQrFormData.fromMap(Map<String, String> map) {
    return LocationQrFormData(location: map['location'] ?? '');
  }

  /// Create empty instance
  factory LocationQrFormData.empty() => const LocationQrFormData(location: '');

  @override
  Map<String, String> toMap() => {'location': location};

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    if (location.trim().isEmpty) {
      errors['location'] = 'Location is required';
    }
    return errors;
  }

  /// Copy with new values
  LocationQrFormData copyWith({String? location}) {
    return LocationQrFormData(location: location ?? this.location);
  }
}

// ============================================================================
// Type Definition
// ============================================================================

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
