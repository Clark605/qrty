/// WiFi security types
enum SecurityType {
  none(''),
  wep('WEP'),
  wpa('WPA'),
  wpa2('WPA');

  const SecurityType(this.value);
  final String value;
}

/// Generates WiFi configuration string for QR codes
class WiFiGenerator {
  /// Generate WiFi configuration string
  /// Format: WIFI:T:{security};S:{ssid};P:{password};H:{hidden};;
  static String generateWiFi({
    required String ssid,
    required String password,
    required SecurityType security,
    bool hidden = false,
  }) {
    final securityType = security == SecurityType.none ? '' : security.value;
    final hiddenFlag = hidden ? 'true' : '';

    return 'WIFI:T:$securityType;S:${_escapeSpecialChars(ssid)};P:${_escapeSpecialChars(password)};H:$hiddenFlag;;';
  }

  /// Escape special characters for WiFi configuration
  static String _escapeSpecialChars(String input) {
    return input
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll(':', '\\:');
  }

  /// Parse security type from string
  static SecurityType parseSecurityType(String type) {
    switch (type.toUpperCase()) {
      case 'WEP':
        return SecurityType.wep;
      case 'WPA':
      case 'WPA2':
        return SecurityType.wpa2;
      case '':
      case 'NONE':
      case 'OPEN':
        return SecurityType.none;
      default:
        return SecurityType.wpa2;
    }
  }
}
