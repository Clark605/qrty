/// Validation utilities for URLs, emails, and phone numbers
///
/// This file consolidates all validation logic used across QR type definitions.

// ============================================================================
// URL Validator
// ============================================================================

/// URL validation utilities
class UrlValidator {
  /// Validate if a string is a valid URL
  static bool isValid(String url) {
    if (url.trim().isEmpty) return false;

    try {
      final uri = Uri.parse(_ensureProtocol(url));
      return uri.hasScheme && uri.hasAuthority && _isValidScheme(uri.scheme);
    } catch (e) {
      return false;
    }
  }

  /// Format URL by adding protocol if missing
  static String format(String url) {
    if (url.trim().isEmpty) return url;
    return _ensureProtocol(url.trim());
  }

  /// Ensure URL has a valid protocol
  static String _ensureProtocol(String url) {
    if (url.startsWith(RegExp(r'https?://', caseSensitive: false))) {
      return url;
    }
    if (url.startsWith(RegExp(r'ftp://', caseSensitive: false))) {
      return url;
    }
    return 'https://$url';
  }

  /// Check if scheme is valid
  static bool _isValidScheme(String scheme) {
    const validSchemes = {'http', 'https', 'ftp'};
    return validSchemes.contains(scheme.toLowerCase());
  }

  /// Validate domain format
  static bool isValidDomain(String domain) {
    if (domain.isEmpty) return false;

    // Basic domain regex pattern
    final domainPattern = RegExp(
      r'^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]?(\.[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]?)*$',
    );

    return domainPattern.hasMatch(domain);
  }
}

// ============================================================================
// Email Validator
// ============================================================================

/// Email validation utilities following RFC 5322
class EmailValidator {
  /// Validate if a string is a valid email address
  static bool isValid(String email) {
    if (email.trim().isEmpty) return false;

    // RFC 5322 compliant regex (simplified)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&'
      '*+/=?^_`{|}~-]+'
      r'@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
      r'(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );

    return emailRegex.hasMatch(email.trim());
  }

  /// Format email for QR code (mailto: format)
  static String formatForQr(String email, {String? subject, String? body}) {
    final trimmedEmail = email.trim();
    if (!isValid(trimmedEmail)) return trimmedEmail;

    final buffer = StringBuffer('mailto:$trimmedEmail');
    final params = <String>[];

    if (subject?.isNotEmpty == true) {
      params.add('subject=${Uri.encodeComponent(subject!)}');
    }

    if (body?.isNotEmpty == true) {
      params.add('body=${Uri.encodeComponent(body!)}');
    }

    if (params.isNotEmpty) {
      buffer.write('?${params.join('&')}');
    }

    return buffer.toString();
  }

  /// Extract email from mailto: URL
  static String extractFromMailto(String mailtoUrl) {
    if (!mailtoUrl.startsWith('mailto:')) return mailtoUrl;

    final uri = Uri.parse(mailtoUrl);
    return uri.path;
  }

  /// Check if email domain is valid
  static bool isValidDomain(String email) {
    if (!isValid(email)) return false;

    final parts = email.split('@');
    if (parts.length != 2) return false;

    final domain = parts[1];

    // Basic domain validation
    final domainRegex = RegExp(r'^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return domainRegex.hasMatch(domain);
  }
}

// ============================================================================
// Phone Validator
// ============================================================================

/// Phone number validation and formatting utilities
class PhoneValidator {
  /// Validate if a string contains a valid phone number
  static bool isValid(String phone) {
    if (phone.trim().isEmpty) return false;

    // Remove all non-digit characters for validation
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Phone number should have at least 7 digits and at most 15 digits (E.164 standard)
    return digitsOnly.length >= 7 && digitsOnly.length <= 15;
  }

  /// Format phone number for QR code (tel: format)
  static String formatForQr(String phone) {
    if (phone.trim().isEmpty) return phone;

    final cleanedPhone = _cleanPhoneNumber(phone);
    return 'tel:$cleanedPhone';
  }

  /// Format phone number for SMS QR code
  static String formatForSms(String phone, {String? message}) {
    if (phone.trim().isEmpty) return phone;

    final cleanedPhone = _cleanPhoneNumber(phone);

    if (message?.isNotEmpty == true) {
      return 'sms:$cleanedPhone?body=${Uri.encodeComponent(message!)}';
    }

    return 'sms:$cleanedPhone';
  }

  /// Format phone number for WhatsApp
  static String formatForWhatsApp(String phone, {String? message}) {
    if (phone.trim().isEmpty) return phone;

    final cleanedPhone = _cleanPhoneNumber(phone);

    if (message?.isNotEmpty == true) {
      return 'https://wa.me/$cleanedPhone?text=${Uri.encodeComponent(message!)}';
    }

    return 'https://wa.me/$cleanedPhone';
  }

  /// Clean and standardize phone number
  static String _cleanPhoneNumber(String phone) {
    // Remove all non-digit characters except +
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure + is only at the beginning
    if (cleaned.contains('+')) {
      final parts = cleaned.split('+');
      cleaned = '+${parts.join('')}';
    }

    return cleaned;
  }

  /// Extract phone number from tel: URL
  static String extractFromTel(String telUrl) {
    if (!telUrl.startsWith('tel:')) return telUrl;
    return telUrl.substring(4);
  }

  /// Check if phone number appears to have international format
  static bool isInternationalFormat(String phone) {
    final cleaned = _cleanPhoneNumber(phone);
    return cleaned.startsWith('+') && cleaned.length > 7;
  }

  /// Format phone for display (add spaces for readability)
  static String formatForDisplay(String phone) {
    final cleaned = _cleanPhoneNumber(phone);

    if (cleaned.startsWith('+')) {
      // International format: +1 234 567 8900
      if (cleaned.length >= 12) {
        return '${cleaned.substring(0, 2)} ${cleaned.substring(2, 5)} ${cleaned.substring(5, 8)} ${cleaned.substring(8)}';
      }
    }

    // Default formatting with spaces every 3 digits
    final buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleaned[i]);
    }

    return buffer.toString();
  }
}
