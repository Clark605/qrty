import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/qr_generators.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/wifi_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

/// Form data model for WiFi QR codes
///
/// Represents WiFi network configuration with SSID, password, security type, and hidden status.
class WifiQrFormData extends QrFormDataBase {
  final String ssid;
  final String password;
  final String security; // 'WPA', 'WEP', or 'Open'
  final bool hidden;

  const WifiQrFormData({
    required this.ssid,
    this.password = '',
    this.security = 'WPA',
    this.hidden = false,
  });

  /// Create from map (deserialization)
  factory WifiQrFormData.fromMap(Map<String, String> map) {
    return WifiQrFormData(
      ssid: map['ssid'] ?? '',
      password: map['password'] ?? '',
      security: map['security'] ?? 'WPA',
      hidden: map['hidden']?.toLowerCase() == 'true',
    );
  }

  /// Create empty instance
  factory WifiQrFormData.empty() => const WifiQrFormData(ssid: '');

  @override
  Map<String, String> toMap() => {
    'ssid': ssid,
    'password': password,
    'security': security,
    'hidden': hidden.toString(),
  };

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};

    if (ssid.trim().isEmpty) {
      errors['ssid'] = 'Network name is required';
    }

    // Password is required for WPA and WEP
    if (security != 'Open' && password.trim().isEmpty) {
      errors['password'] = 'Password is required for $security security';
    }

    // Validate security type
    if (!['WPA', 'WEP', 'Open'].contains(security)) {
      errors['security'] = 'Invalid security type';
    }

    return errors;
  }

  /// Copy with new values
  WifiQrFormData copyWith({
    String? ssid,
    String? password,
    String? security,
    bool? hidden,
  }) {
    return WifiQrFormData(
      ssid: ssid ?? this.ssid,
      password: password ?? this.password,
      security: security ?? this.security,
      hidden: hidden ?? this.hidden,
    );
  }
}

// ============================================================================
// Type Definition
// ============================================================================

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
