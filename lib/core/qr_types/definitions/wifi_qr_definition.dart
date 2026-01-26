import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/wifi_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/qr_data_generators/wifi_generator.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/wifi_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Definition for WiFi QR type
///
/// Handles WiFi network configuration QR codes with SSID, password,
/// security type (WPA/WEP/Open), and hidden network settings.
class WifiQrDefinition extends QrTypeDefinition<WifiQrFormData> {
  @override
  QRCodeType get type => QRCodeType.wifi;

  @override
  String get displayName => LocaleKeys.wifi.tr();

  @override
  String get icon => AppAssets.wifi;

  @override
  WifiQrFormData createEmpty() => WifiQrFormData.empty();

  @override
  WifiQrFormData fromMap(Map<String, String> map) {
    return WifiQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const WifiQrFormScreen();
  }

  @override
  String generateQrData(WifiQrFormData formData) {
    // Map security string to SecurityType enum
    final securityType = _parseSecurityType(formData.security);

    return WiFiGenerator.generateWiFi(
      ssid: formData.ssid,
      password: formData.password,
      security: securityType,
      hidden: formData.hidden,
    );
  }

  @override
  Map<String, String> validateData(WifiQrFormData formData) {
    return formData.validate();
  }

  /// Parse security type string to SecurityType enum
  SecurityType _parseSecurityType(String type) {
    switch (type.toUpperCase()) {
      case 'WEP':
        return SecurityType.wep;
      case 'WPA':
      case 'WPA2':
        return SecurityType.wpa2;
      case 'OPEN':
      case '':
        return SecurityType.none;
      default:
        return SecurityType.wpa2; // Default to WPA
    }
  }
}
