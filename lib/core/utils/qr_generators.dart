/// QR code format generators for WiFi, vCard, and iCal formats
///
/// This file consolidates all QR format generators following industry standards.

// ============================================================================
// WiFi Generator
// ============================================================================

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

// ============================================================================
// vCard Generator
// ============================================================================

/// Generates vCard 3.0 format for contacts and business cards
class VCardGenerator {
  /// Generate vCard for contact information
  static String generateContact({
    required String firstName,
    required String lastName,
    String? company,
    String? job,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? country,
  }) {
    final vcard = StringBuffer();
    vcard.writeln('BEGIN:VCARD');
    vcard.writeln('VERSION:3.0');

    // Full name
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      vcard.writeln('FN:$firstName $lastName'.trim());
      vcard.writeln('N:$lastName;$firstName;;;');
    }

    // Organization and title
    if (company?.isNotEmpty == true) {
      vcard.writeln('ORG:$company');
    }
    if (job?.isNotEmpty == true) {
      vcard.writeln('TITLE:$job');
    }

    // Contact information
    if (phone?.isNotEmpty == true) {
      vcard.writeln('TEL:$phone');
    }
    if (email?.isNotEmpty == true) {
      vcard.writeln('EMAIL:$email');
    }
    if (website?.isNotEmpty == true) {
      vcard.writeln('URL:$website');
    }

    // Address
    if (address?.isNotEmpty == true) {
      final addressParts = [
        '', // PO Box (empty)
        '', // Extended address (empty)
        address ?? '',
        city ?? '',
        state ?? '',
        zip ?? '',
        country ?? '',
      ];
      vcard.writeln('ADR:${addressParts.join(';')}');
    }

    vcard.writeln('END:VCARD');
    return vcard.toString();
  }

  /// Generate vCard for business card
  static String generateBusiness({
    required String company,
    String? industry,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? country,
  }) {
    final vcard = StringBuffer();
    vcard.writeln('BEGIN:VCARD');
    vcard.writeln('VERSION:3.0');

    // Company as the primary name
    vcard.writeln('FN:$company');
    vcard.writeln('ORG:$company');

    // Industry as category
    if (industry?.isNotEmpty == true) {
      vcard.writeln('CATEGORIES:$industry');
    }

    // Contact information
    if (phone?.isNotEmpty == true) {
      vcard.writeln('TEL:$phone');
    }
    if (email?.isNotEmpty == true) {
      vcard.writeln('EMAIL:$email');
    }
    if (website?.isNotEmpty == true) {
      vcard.writeln('URL:$website');
    }

    // Address
    if (address?.isNotEmpty == true) {
      final addressParts = [
        '', // PO Box (empty)
        '', // Extended address (empty)
        address ?? '',
        city ?? '',
        state ?? '',
        zip ?? '',
        country ?? '',
      ];
      vcard.writeln('ADR:${addressParts.join(';')}');
    }

    vcard.writeln('END:VCARD');
    return vcard.toString();
  }
}

// ============================================================================
// iCal Generator
// ============================================================================

/// Generates iCal format for events following RFC 5545
class ICalGenerator {
  /// Generate iCal format for events
  static String generateEvent({
    required String summary,
    required DateTime startDate,
    DateTime? endDate,
    String? location,
    String? description,
  }) {
    final event = StringBuffer();
    event.writeln('BEGIN:VCALENDAR');
    event.writeln('VERSION:2.0');
    event.writeln('PRODID:-//QRty App//Event Generator//EN');
    event.writeln('BEGIN:VEVENT');

    // Unique identifier
    final uid = DateTime.now().millisecondsSinceEpoch.toString();
    event.writeln('UID:$uid@qrty.app');

    // Date created
    final now = _formatDateTime(DateTime.now());
    event.writeln('DTSTAMP:$now');

    // Event summary
    event.writeln('SUMMARY:${_escapeText(summary)}');

    // Start date
    event.writeln('DTSTART:${_formatDateTime(startDate)}');

    // End date
    if (endDate != null) {
      event.writeln('DTEND:${_formatDateTime(endDate)}');
    }

    // Location
    if (location?.isNotEmpty == true) {
      event.writeln('LOCATION:${_escapeText(location!)}');
    }

    // Description
    if (description?.isNotEmpty == true) {
      event.writeln('DESCRIPTION:${_escapeText(description!)}');
    }

    event.writeln('END:VEVENT');
    event.writeln('END:VCALENDAR');
    return event.toString();
  }

  /// Format DateTime to iCal format (YYYYMMDDTHHMMSSZ)
  static String _formatDateTime(DateTime dateTime) {
    final utc = dateTime.toUtc();
    return '${utc.year.toString().padLeft(4, '0')}'
        '${utc.month.toString().padLeft(2, '0')}'
        '${utc.day.toString().padLeft(2, '0')}'
        'T'
        '${utc.hour.toString().padLeft(2, '0')}'
        '${utc.minute.toString().padLeft(2, '0')}'
        '${utc.second.toString().padLeft(2, '0')}'
        'Z';
  }

  /// Escape text for iCal format
  static String _escapeText(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll('\n', '\\n');
  }
}
