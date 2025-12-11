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
