import 'package:flutter/material.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/text_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/url_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/email_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/phone_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/sms_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/twitter_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/instagram_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/location_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/wifi_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/contact_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/business_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/event_qr_form_screen.dart';

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

      // Complex form types
      case QRCodeType.wifi:
        return const WifiQrFormScreen();

      case QRCodeType.vcard:
        return const ContactQrFormScreen();

      case QRCodeType.business:
        return const BusinessQrFormScreen();

      case QRCodeType.event:
        return const EventQrFormScreen();
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
