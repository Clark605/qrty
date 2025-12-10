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
