import 'package:qrty/core/models/qr_form_data/qr_form_data_base.dart';

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
