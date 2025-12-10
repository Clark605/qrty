import 'package:flutter/material.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/feature/generate_qr/view/forms/text_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/url_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/email_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/phone_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/sms_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/twitter_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/instagram_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/location_qr_form_screen.dart';

/// Factory class to create QR form screens based on QR type
class QrFormScreenFactory {
  static Widget? createFormScreen(QRCodeType type) {
    switch (type) {
      case QRCodeType.text:
        return const TextQrFormScreen();

      case QRCodeType.url:
        return const UrlQrFormScreen();

      case QRCodeType.email:
        return const EmailQrFormScreen();

      case QRCodeType.phone:
        return const PhoneQrFormScreen();

      case QRCodeType.sms:
        return const SmsQrFormScreen();

      case QRCodeType.twitter:
        return const TwitterQrFormScreen();

      case QRCodeType.instagram:
        return const InstagramQrFormScreen();

      case QRCodeType.location:
        return const LocationQrFormScreen();

      // Complex form types will be handled in Commit 6
      case QRCodeType.wifi:
      case QRCodeType.vcard:
      case QRCodeType.business:
      case QRCodeType.event:
        return null; // Will be implemented in next commit
    }
  }

  /// Check if a QR type has a form screen implemented
  static bool hasFormScreen(QRCodeType type) {
    return createFormScreen(type) != null;
  }

  /// Get display name for QR type in navigation
  static String getDisplayName(QRCodeType type) {
    switch (type) {
      case QRCodeType.text:
        return 'Text';
      case QRCodeType.url:
        return 'Website';
      case QRCodeType.email:
        return 'Email';
      case QRCodeType.phone:
        return 'Phone';
      case QRCodeType.sms:
        return 'WhatsApp';
      case QRCodeType.twitter:
        return 'Twitter';
      case QRCodeType.instagram:
        return 'Instagram';
      case QRCodeType.location:
        return 'Location';
      case QRCodeType.wifi:
        return 'Wi-Fi';
      case QRCodeType.vcard:
        return 'Contact';
      case QRCodeType.business:
        return 'Business';
      case QRCodeType.event:
        return 'Event';
    }
  }
}
