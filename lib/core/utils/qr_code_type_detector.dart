import 'package:qrty/core/enums/qr_code_type_enum.dart';

class QRCodeTypeDetector {
  static QRCodeType detectType(String data) {
    // WiFi format: WIFI:T:WPA;S:NetworkName;P:password;;
    if (data.toUpperCase().startsWith('WIFI:')) {
      return QRCodeType.wifi;
    }

    // URL format
    if (data.startsWith('http://') ||
        data.startsWith('https://') ||
        data.startsWith('www.')) {
      return QRCodeType.url;
    }

    // Email format: mailto:email@example.com or MATMSG:TO:email@example.com;
    if (data.startsWith('mailto:') ||
        data.toUpperCase().startsWith('MATMSG:')) {
      return QRCodeType.email;
    }

    // Phone format: tel:+1234567890
    if (data.startsWith('tel:')) {
      return QRCodeType.phone;
    }

    // SMS format: sms:+1234567890 or SMSTO:+1234567890:message
    if (data.startsWith('sms:') || data.toUpperCase().startsWith('SMSTO:')) {
      return QRCodeType.sms;
    }

    // vCard format: BEGIN:VCARD
    if (data.toUpperCase().startsWith('BEGIN:VCARD')) {
      return QRCodeType.vcard;
    }

    // Location format: geo:latitude,longitude
    if (data.startsWith('geo:')) {
      return QRCodeType.location;
    }

    // Default to text
    return QRCodeType.text;
  }
}
