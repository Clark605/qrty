import 'package:qrty/core/enums/qr_code_type_enum.dart';

class QrTextFormatter {
  static String formatText(String text, QRCodeType type) {
    switch (type) {
      case QRCodeType.url:
        return text;

      case QRCodeType.email:
        // Extract email from formats: mailto:email@example.com or MATMSG:TO:email@example.com;SUB:subject;BODY:body;;
        if (text.startsWith('mailto:')) {
          return text.substring(7).split('?').first;
        } else if (text.toUpperCase().startsWith('MATMSG:')) {
          final match = RegExp(
            r'TO:(.*?);',
            caseSensitive: false,
          ).firstMatch(text);
          return match?.group(1) ?? text;
        }
        return text;

      case QRCodeType.phone:
        // Extract phone from format: tel:+1234567890
        if (text.startsWith('tel:')) {
          return text.substring(4);
        }
        return text;

      case QRCodeType.sms:
        // Extract phone and message from formats: sms:+1234567890?body=message or SMSTO:+1234567890:message
        if (text.startsWith('sms:')) {
          final uri = Uri.parse(text);
          final phone = uri.path;
          final body = uri.queryParameters['body'];
          return body != null ? '$phone\n$body' : phone;
        } else if (text.toUpperCase().startsWith('SMSTO:')) {
          return text.substring(6).replaceFirst(':', '\n');
        }
        return text;

      case QRCodeType.wifi:
        // Parse WiFi format: WIFI:T:WPA;S:NetworkName;P:password;H:hidden;;
        final Map<String, String> wifiData = {};
        final regex = RegExp(r'([TSPHN]):(.*?);');
        for (final match in regex.allMatches(text)) {
          wifiData[match.group(1)!] = match.group(2)!;
        }

        final ssid = wifiData['S'] ?? '';
        final password = wifiData['P'] ?? '';
        final security = wifiData['T'] ?? 'OPEN';

        if (password.isEmpty) {
          return 'Network: $ssid\nSecurity: $security';
        }
        return 'Network: $ssid\nPassword: $password\nSecurity: $security';

      case QRCodeType.location:
        // Parse geo format: geo:latitude,longitude or geo:latitude,longitude?q=label
        if (text.startsWith('geo:')) {
          final geoData = text.substring(4);
          final coords = geoData.split('?').first.split(',');
          if (coords.length >= 2) {
            final lat = coords[0];
            final lng = coords[1];
            return 'Latitude: $lat\nLongitude: $lng';
          }
        }
        return text;

      case QRCodeType.vcard:
        // Parse vCard format and extract key information
        final lines = text.split('\n');
        String name = '';
        String phone = '';
        String email = '';
        String org = '';

        for (final line in lines) {
          if (line.startsWith('FN:')) {
            name = line.substring(3);
          } else if (line.startsWith('TEL')) {
            phone = line.split(':').last;
          } else if (line.startsWith('EMAIL')) {
            email = line.split(':').last;
          } else if (line.startsWith('ORG:')) {
            org = line.substring(4);
          }
        }

        final parts = <String>[];
        if (name.isNotEmpty) parts.add('Name: $name');
        if (phone.isNotEmpty) parts.add('Phone: $phone');
        if (email.isNotEmpty) parts.add('Email: $email');
        if (org.isNotEmpty) parts.add('Organization: $org');

        return parts.isEmpty ? text : parts.join('\n');

      case QRCodeType.text:
        return text;
    }
  }
}
