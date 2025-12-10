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
