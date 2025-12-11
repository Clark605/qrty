import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/utils/qr_data_generators/vcard_generator.dart';
import 'package:qrty/core/utils/qr_data_generators/ical_generator.dart';
import 'package:qrty/core/utils/qr_data_generators/wifi_generator.dart';
import 'package:qrty/core/utils/qr_data_generators/url_validator.dart';
import 'package:qrty/core/utils/qr_data_generators/email_validator.dart';
import 'package:qrty/core/utils/qr_data_generators/phone_validator.dart';

/// Unified QR content generator that handles all QR types
class QrContentGenerator {
  /// Generate QR data based on type and form data
  static String generateQrData(QRCodeType type, Map<String, String> formData) {
    switch (type) {
      case QRCodeType.text:
        return formData['text'] ?? '';

      case QRCodeType.url:
        final url = formData['url'] ?? '';
        return UrlValidator.format(url);

      case QRCodeType.email:
        final email = formData['email'] ?? '';
        final subject = formData['subject'];
        final body = formData['body'];
        return EmailValidator.formatForQr(email, subject: subject, body: body);

      case QRCodeType.phone:
        final phone = formData['phone'] ?? '';
        return PhoneValidator.formatForQr(phone);

      case QRCodeType.sms:
        final phone = formData['phone'] ?? '';
        final message = formData['message'];
        return PhoneValidator.formatForSms(phone, message: message);

      case QRCodeType.wifi:
        final ssid = formData['ssid'] ?? '';
        final password = formData['password'] ?? '';
        final securityType = formData['security'] ?? 'WPA';
        final hidden = formData['hidden'] == 'true';

        return WiFiGenerator.generateWiFi(
          ssid: ssid,
          password: password,
          security: WiFiGenerator.parseSecurityType(securityType),
          hidden: hidden,
        );

      case QRCodeType.vcard:
        return VCardGenerator.generateContact(
          firstName: formData['firstName'] ?? '',
          lastName: formData['lastName'] ?? '',
          company: formData['company'],
          job: formData['job'],
          phone: formData['phone'],
          email: formData['email'],
          website: formData['website'],
          address: formData['address'],
          city: formData['city'],
          state: formData['state'],
          zip: formData['zip'],
          country: formData['country'],
        );

      case QRCodeType.business:
        return VCardGenerator.generateBusiness(
          company: formData['company'] ?? '',
          industry: formData['industry'],
          phone: formData['phone'],
          email: formData['email'],
          website: formData['website'],
          address: formData['address'],
          city: formData['city'],
          state: formData['state'],
          zip: formData['zip'],
          country: formData['country'],
        );

      case QRCodeType.event:
        final summary = formData['summary'] ?? '';
        final startDateStr = formData['startDate'] ?? '';
        final endDateStr = formData['endDate'];

        // Parse dates (assuming ISO format for now)
        DateTime? startDate;
        DateTime? endDate;

        try {
          if (startDateStr.isNotEmpty) {
            startDate = DateTime.parse(startDateStr);
          }
          if (endDateStr?.isNotEmpty == true) {
            endDate = DateTime.parse(endDateStr!);
          }
        } catch (e) {
          // Fallback to current time if parsing fails
          startDate = DateTime.now();
        }

        return ICalGenerator.generateEvent(
          summary: summary,
          startDate: startDate ?? DateTime.now(),
          endDate: endDate,
          location: formData['location'],
          description: formData['description'],
        );

      case QRCodeType.location:
        final location = formData['location'] ?? '';
        // For now, return as text. Could be enhanced to support geo: format
        return location;

      case QRCodeType.twitter:
        final handle = formData['handle'] ?? '';
        final cleanHandle = handle.replaceFirst('@', '');
        return 'https://twitter.com/$cleanHandle';

      case QRCodeType.instagram:
        final handle = formData['handle'] ?? '';
        final cleanHandle = handle.replaceFirst('@', '');
        return 'https://instagram.com/$cleanHandle';
    }
  }

  /// Validate form data based on QR type
  static Map<String, String> validateFormData(
    QRCodeType type,
    Map<String, String> formData,
  ) {
    final errors = <String, String>{};

    switch (type) {
      case QRCodeType.text:
        if ((formData['text']?.trim().isEmpty ?? true)) {
          errors['text'] = 'Text is required';
        }
        break;

      case QRCodeType.url:
        final url = formData['url']?.trim() ?? '';
        if (url.isEmpty) {
          errors['url'] = 'URL is required';
        } else if (!UrlValidator.isValid(url)) {
          errors['url'] = 'Please enter a valid URL';
        }
        break;

      case QRCodeType.email:
        final email = formData['email']?.trim() ?? '';
        if (email.isEmpty) {
          errors['email'] = 'Email is required';
        } else if (!EmailValidator.isValid(email)) {
          errors['email'] = 'Please enter a valid email address';
        }
        break;

      case QRCodeType.phone:
      case QRCodeType.sms:
        final phone = formData['phone']?.trim() ?? '';
        if (phone.isEmpty) {
          errors['phone'] = 'Phone number is required';
        } else if (!PhoneValidator.isValid(phone)) {
          errors['phone'] = 'Please enter a valid phone number';
        }
        break;

      case QRCodeType.wifi:
        if ((formData['ssid']?.trim().isEmpty ?? true)) {
          errors['ssid'] = 'Network name (SSID) is required';
        }
        final security = formData['security'] ?? 'WPA';
        if (security != 'NONE' &&
            security != 'OPEN' &&
            (formData['password']?.trim().isEmpty ?? true)) {
          errors['password'] = 'Password is required for secured networks';
        }
        break;

      case QRCodeType.vcard:
        final firstName = formData['firstName']?.trim() ?? '';
        final lastName = formData['lastName']?.trim() ?? '';
        if (firstName.isEmpty && lastName.isEmpty) {
          errors['firstName'] = 'At least first or last name is required';
        }
        break;

      case QRCodeType.business:
        if ((formData['company']?.trim().isEmpty ?? true)) {
          errors['company'] = 'Company name is required';
        }
        break;

      case QRCodeType.event:
        if ((formData['summary']?.trim().isEmpty ?? true)) {
          errors['summary'] = 'Event name is required';
        }
        if ((formData['startDate']?.trim().isEmpty ?? true)) {
          errors['startDate'] = 'Start date is required';
        }
        break;

      case QRCodeType.location:
        if ((formData['location']?.trim().isEmpty ?? true)) {
          errors['location'] = 'Location is required';
        }
        break;

      case QRCodeType.twitter:
      case QRCodeType.instagram:
        if ((formData['handle']?.trim().isEmpty ?? true)) {
          errors['handle'] = 'Handle is required';
        }
        break;
    }

    return errors;
  }
}
