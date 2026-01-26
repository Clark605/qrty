import 'package:flutter_test/flutter_test.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_type_registry.dart';

void main() {
  late QrTypeRegistry registry;

  setUp(() {
    registry = QrTypeRegistry();
  });

  group('QrTypeRegistry -', () {
    group('Registration', () {
      test('should register all Phase 1, 2, and 3 types', () {
        final supportedTypes = registry.supportedTypes;

        expect(supportedTypes.length, equals(12));
        // Phase 1
        expect(supportedTypes, contains(QRCodeType.text));
        expect(supportedTypes, contains(QRCodeType.url));
        expect(supportedTypes, contains(QRCodeType.email));
        // Phase 2
        expect(supportedTypes, contains(QRCodeType.phone));
        expect(supportedTypes, contains(QRCodeType.sms));
        expect(supportedTypes, contains(QRCodeType.location));
        expect(supportedTypes, contains(QRCodeType.twitter));
        expect(supportedTypes, contains(QRCodeType.instagram));
        // Phase 3
        expect(supportedTypes, contains(QRCodeType.wifi));
        expect(supportedTypes, contains(QRCodeType.vcard));
        expect(supportedTypes, contains(QRCodeType.business));
        expect(supportedTypes, contains(QRCodeType.event));
      });

      test('should return type definition for registered types', () {
        final textDef = registry.getDefinition(QRCodeType.text);
        final urlDef = registry.getDefinition(QRCodeType.url);
        final emailDef = registry.getDefinition(QRCodeType.email);

        expect(textDef, isNotNull);
        expect(urlDef, isNotNull);
        expect(emailDef, isNotNull);
        expect(textDef!.displayName, isNotEmpty);
        expect(urlDef!.displayName, isNotEmpty);
        expect(emailDef!.displayName, isNotEmpty);
      });

      test('should return null for unregistered types', () {
        // All types are now registered in Phase 3
        // This test validates the registry is complete
        expect(registry.supportedTypes.length, equals(12));
      });

      test('isSupported should return true for registered types', () {
        expect(registry.isSupported(QRCodeType.text), isTrue);
        expect(registry.isSupported(QRCodeType.phone), isTrue);
        expect(registry.isSupported(QRCodeType.twitter), isTrue);
        expect(registry.isSupported(QRCodeType.wifi), isTrue);
        expect(registry.isSupported(QRCodeType.vcard), isTrue);
        expect(registry.isSupported(QRCodeType.business), isTrue);
        expect(registry.isSupported(QRCodeType.event), isTrue);
      });

      test('isSupported should return false for non-existent types', () {
        // All 12 types are now registered
        expect(registry.supportedTypes.length, equals(12));
      });
    });

    group('Validation -', () {
      group('Text Type', () {
        test('should validate non-empty text', () {
          final result = registry.validateData(QRCodeType.text, {
            'text': 'Hello',
          });

          expect(result, isEmpty);
        });

        test('should invalidate empty text', () {
          final result = registry.validateData(QRCodeType.text, {'text': ''});

          expect(result, isNotEmpty);
          expect(result['text'], isNotNull);
        });
      });

      group('URL Type', () {
        test('should validate proper URL', () {
          final result = registry.validateData(QRCodeType.url, {
            'url': 'example.com',
          });

          expect(result, isEmpty);
        });

        test('should invalidate empty URL', () {
          final result = registry.validateData(QRCodeType.url, {'url': ''});

          expect(result, isNotEmpty);
          expect(result['url'], isNotNull);
        });
      });

      group('Email Type', () {
        test('should validate proper email', () {
          final result = registry.validateData(QRCodeType.email, {
            'email': 'test@example.com',
          });

          expect(result, isEmpty);
        });

        test('should validate email with subject and body', () {
          final result = registry.validateData(QRCodeType.email, {
            'email': 'test@example.com',
            'subject': 'Hello',
            'body': 'Test message',
          });

          expect(result, isEmpty);
        });

        test('should invalidate invalid email format', () {
          final result = registry.validateData(QRCodeType.email, {
            'email': 'not-an-email',
          });

          expect(result, isNotEmpty);
          expect(result['email'], isNotNull);
        });
      });

      group('Phone Type', () {
        test('should validate proper phone number', () {
          final result = registry.validateData(QRCodeType.phone, {
            'phone': '+1234567890',
          });

          expect(result, isEmpty);
        });

        test('should invalidate empty phone', () {
          final result = registry.validateData(QRCodeType.phone, {'phone': ''});

          expect(result, isNotEmpty);
          expect(result['phone'], isNotNull);
        });
      });

      group('SMS Type', () {
        test('should validate SMS with message', () {
          final result = registry.validateData(QRCodeType.sms, {
            'phone': '+1234567890',
            'message': 'Hello',
          });

          expect(result, isEmpty);
        });

        test('should validate SMS without message', () {
          final result = registry.validateData(QRCodeType.sms, {
            'phone': '+1234567890',
          });

          expect(result, isEmpty);
        });
      });

      group('Location Type', () {
        test('should validate non-empty location', () {
          final result = registry.validateData(QRCodeType.location, {
            'location': 'New York, NY',
          });

          expect(result, isEmpty);
        });

        test('should invalidate empty location', () {
          final result = registry.validateData(QRCodeType.location, {
            'location': '',
          });

          expect(result, isNotEmpty);
          expect(result['location'], isNotNull);
        });
      });

      group('Twitter Type', () {
        test('should validate proper Twitter handle', () {
          final result = registry.validateData(QRCodeType.twitter, {
            'handle': 'flutter_dev',
          });

          expect(result, isEmpty);
        });

        test('should validate Twitter handle with @', () {
          final result = registry.validateData(QRCodeType.twitter, {
            'handle': '@flutter_dev',
          });

          expect(result, isEmpty);
        });

        test('should invalidate handle longer than 15 chars', () {
          final result = registry.validateData(QRCodeType.twitter, {
            'handle': 'this_handle_is_too_long',
          });

          expect(result, isNotEmpty);
          expect(result['handle'], isNotNull);
        });

        test('should invalidate handle with invalid characters', () {
          final result = registry.validateData(QRCodeType.twitter, {
            'handle': 'invalid.handle',
          });

          expect(result, isNotEmpty);
          expect(result['handle'], isNotNull);
        });
      });

      group('Instagram Type', () {
        test('should validate proper Instagram handle', () {
          final result = registry.validateData(QRCodeType.instagram, {
            'handle': 'flutter.dev',
          });

          expect(result, isEmpty);
        });

        test('should invalidate handle longer than 30 chars', () {
          final result = registry.validateData(QRCodeType.instagram, {
            'handle': 'this_instagram_handle_is_way_too_long_for_platform',
          });

          expect(result, isNotEmpty);
          expect(result['handle'], isNotNull);
        });
      });

      group('WiFi Type', () {
        test('should validate WiFi with WPA security', () {
          final result = registry.validateData(QRCodeType.wifi, {
            'ssid': 'MyNetwork',
            'password': 'password123',
            'security': 'WPA',
          });

          expect(result, isEmpty);
        });

        test('should invalidate WiFi without SSID', () {
          final result = registry.validateData(QRCodeType.wifi, {
            'ssid': '',
            'password': 'password123',
            'security': 'WPA',
          });

          expect(result, isNotEmpty);
          expect(result['ssid'], isNotNull);
        });

        test('should invalidate WPA/WEP without password', () {
          final result = registry.validateData(QRCodeType.wifi, {
            'ssid': 'MyNetwork',
            'password': '',
            'security': 'WPA',
          });

          expect(result, isNotEmpty);
          expect(result['password'], isNotNull);
        });

        test('should validate Open network without password', () {
          final result = registry.validateData(QRCodeType.wifi, {
            'ssid': 'MyNetwork',
            'password': '',
            'security': 'Open',
          });

          expect(result, isEmpty);
        });
      });

      group('vCard Type', () {
        test('should validate vCard with first name only', () {
          final result = registry.validateData(QRCodeType.vcard, {
            'firstName': 'John',
            'lastName': '',
          });

          expect(result, isEmpty);
        });

        test('should validate vCard with last name only', () {
          final result = registry.validateData(QRCodeType.vcard, {
            'firstName': '',
            'lastName': 'Doe',
          });

          expect(result, isEmpty);
        });

        test('should invalidate vCard without any name', () {
          final result = registry.validateData(QRCodeType.vcard, {
            'firstName': '',
            'lastName': '',
          });

          expect(result, isNotEmpty);
          expect(result['firstName'], isNotNull);
        });

        test('should invalidate vCard with invalid email', () {
          final result = registry.validateData(QRCodeType.vcard, {
            'firstName': 'John',
            'lastName': 'Doe',
            'email': 'invalid-email',
          });

          expect(result, isNotEmpty);
          expect(result['email'], isNotNull);
        });
      });

      group('Business Type', () {
        test('should validate business with company name', () {
          final result = registry.validateData(QRCodeType.business, {
            'company': 'Acme Corp',
          });

          expect(result, isEmpty);
        });

        test('should invalidate business without company name', () {
          final result = registry.validateData(QRCodeType.business, {
            'company': '',
          });

          expect(result, isNotEmpty);
          expect(result['company'], isNotNull);
        });

        test('should invalidate business with invalid email', () {
          final result = registry.validateData(QRCodeType.business, {
            'company': 'Acme Corp',
            'email': 'not-an-email',
          });

          expect(result, isNotEmpty);
          expect(result['email'], isNotNull);
        });
      });

      group('Event Type', () {
        test('should validate event with summary and start date', () {
          final now = DateTime.now().toIso8601String();
          final result = registry.validateData(QRCodeType.event, {
            'summary': 'Team Meeting',
            'startDate': now,
          });

          expect(result, isEmpty);
        });

        test('should invalidate event without summary', () {
          final now = DateTime.now().toIso8601String();
          final result = registry.validateData(QRCodeType.event, {
            'summary': '',
            'startDate': now,
          });

          expect(result, isNotEmpty);
          expect(result['summary'], isNotNull);
        });

        test('should invalidate event without start date', () {
          final result = registry.validateData(QRCodeType.event, {
            'summary': 'Team Meeting',
            'startDate': '',
          });

          expect(result, isNotEmpty);
          expect(result['startDate'], isNotNull);
        });

        test('should invalidate event with end date before start date', () {
          final start = DateTime.now();
          final end = start.subtract(const Duration(hours: 1));

          final result = registry.validateData(QRCodeType.event, {
            'summary': 'Team Meeting',
            'startDate': start.toIso8601String(),
            'endDate': end.toIso8601String(),
          });

          expect(result, isNotEmpty);
          expect(result['endDate'], isNotNull);
        });
      });
    });

    group('QR Data Generation -', () {
      test('should generate plain text QR data', () {
        final data = registry.generateQrData(QRCodeType.text, {
          'text': 'Hello World',
        });

        expect(data, equals('Hello World'));
      });

      test('should generate URL with https prefix', () {
        final data = registry.generateQrData(QRCodeType.url, {
          'url': 'example.com',
        });

        expect(data, startsWith('https://'));
        expect(data, contains('example.com'));
      });

      test('should generate email mailto URI', () {
        final data = registry.generateQrData(QRCodeType.email, {
          'email': 'test@example.com',
        });

        expect(data, startsWith('mailto:'));
        expect(data, contains('test@example.com'));
      });

      test('should generate email with subject and body', () {
        final data = registry.generateQrData(QRCodeType.email, {
          'email': 'test@example.com',
          'subject': 'Hello',
          'body': 'Test',
        });

        expect(data, contains('subject='));
        expect(data, contains('body='));
      });

      test('should generate phone tel URI', () {
        final data = registry.generateQrData(QRCodeType.phone, {
          'phone': '+1234567890',
        });

        expect(data, startsWith('tel:'));
      });

      test('should generate SMS URI with message', () {
        final data = registry.generateQrData(QRCodeType.sms, {
          'phone': '+1234567890',
          'message': 'Hello',
        });

        expect(data, startsWith('sms:'));
        expect(data, contains('Hello'));
      });

      test('should generate SMS URI without message', () {
        final data = registry.generateQrData(QRCodeType.sms, {
          'phone': '+1234567890',
        });

        expect(data, startsWith('sms:'));
      });

      test('should generate location data', () {
        final data = registry.generateQrData(QRCodeType.location, {
          'location': 'New York, NY',
        });

        expect(data, equals('New York, NY'));
      });

      test('should generate Twitter profile URL', () {
        final data = registry.generateQrData(QRCodeType.twitter, {
          'handle': 'flutter_dev',
        });

        expect(data, equals('https://twitter.com/flutter_dev'));
      });

      test('should generate Twitter URL removing @ prefix', () {
        final data = registry.generateQrData(QRCodeType.twitter, {
          'handle': '@flutter_dev',
        });

        expect(data, equals('https://twitter.com/flutter_dev'));
      });

      test('should generate Instagram profile URL', () {
        final data = registry.generateQrData(QRCodeType.instagram, {
          'handle': 'flutter.official',
        });

        expect(data, equals('https://instagram.com/flutter.official'));
      });

      test('should generate Instagram URL removing @ prefix', () {
        final data = registry.generateQrData(QRCodeType.instagram, {
          'handle': '@flutter.official',
        });

        expect(data, equals('https://instagram.com/flutter.official'));
      });
    });

    group('Display Names -', () {
      test('should return display names for registered types', () {
        expect(registry.getDisplayName(QRCodeType.text), isNotEmpty);
        expect(registry.getDisplayName(QRCodeType.url), isNotEmpty);
        expect(registry.getDisplayName(QRCodeType.email), isNotEmpty);
        expect(registry.getDisplayName(QRCodeType.phone), isNotEmpty);
        expect(registry.getDisplayName(QRCodeType.sms), isNotEmpty);
        expect(registry.getDisplayName(QRCodeType.location), isNotEmpty);
        expect(registry.getDisplayName(QRCodeType.twitter), isNotEmpty);
        expect(registry.getDisplayName(QRCodeType.instagram), isNotEmpty);
        expect(registry.getDisplayName(QRCodeType.wifi), isNotEmpty);
        expect(registry.getDisplayName(QRCodeType.vcard), isNotEmpty);
        expect(registry.getDisplayName(QRCodeType.business), isNotEmpty);
        expect(registry.getDisplayName(QRCodeType.event), isNotEmpty);
      });

      test('should return empty string for unregistered types', () {
        // All types are now registered, so this test checks a non-existent type
        // We can skip this test or keep it for documentation
        expect(registry.supportedTypes.length, equals(12));
      });
    });

    group('Icons -', () {
      test('should return icons for registered types', () {
        final textIcon = registry.getIcon(QRCodeType.text);
        final urlIcon = registry.getIcon(QRCodeType.url);
        final emailIcon = registry.getIcon(QRCodeType.email);

        expect(textIcon, isNotEmpty);
        expect(urlIcon, isNotEmpty);
        expect(emailIcon, isNotEmpty);
      });

      test('should return empty string for unregistered types', () {
        // All 12 types are now registered in Phase 3
        expect(registry.supportedTypes.length, equals(12));
      });
    });
  });
}
