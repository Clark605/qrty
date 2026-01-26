import 'package:flutter/material.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/qr_types/definitions/text_qr_definition.dart';
import 'package:qrty/core/qr_types/definitions/url_qr_definition.dart';
import 'package:qrty/core/qr_types/definitions/email_qr_definition.dart';
import 'package:qrty/core/qr_types/definitions/phone_qr_definition.dart';
import 'package:qrty/core/qr_types/definitions/sms_qr_definition.dart';
import 'package:qrty/core/qr_types/definitions/location_qr_definition.dart';
import 'package:qrty/core/qr_types/definitions/twitter_qr_definition.dart';
import 'package:qrty/core/qr_types/definitions/instagram_qr_definition.dart';
import 'package:qrty/core/qr_types/definitions/wifi_qr_definition.dart';
import 'package:qrty/core/qr_types/definitions/vcard_qr_definition.dart';
import 'package:qrty/core/qr_types/definitions/business_qr_definition.dart';
import 'package:qrty/core/qr_types/definitions/event_qr_definition.dart';

/// Central registry for QR type definitions
///
/// Provides a single source of truth for all QR type behaviors.
/// Uses singleton pattern to ensure consistent access throughout the app.
///
/// ## Usage
/// ```dart
/// final registry = QrTypeRegistry();
/// final definition = registry.getDefinition(QRCodeType.text);
/// final formScreen = registry.buildForm(QRCodeType.url, context);
/// ```
///
/// ## Extensibility
/// To add a new QR type:
/// 1. Create a new QrFormData class
/// 2. Create a new QrTypeDefinition class
/// 3. Register it in [_registerTypes]
class QrTypeRegistry {
  // Singleton pattern
  static final QrTypeRegistry _instance = QrTypeRegistry._internal();
  factory QrTypeRegistry() => _instance;

  QrTypeRegistry._internal() {
    _registerTypes();
  }

  /// Internal registry mapping QR types to their definitions
  final Map<QRCodeType, QrTypeDefinition> _registry = {};

  /// Register all QR type definitions
  ///
  /// This is where all supported QR types are registered.
  /// Add new type registrations here.
  void _registerTypes() {
    // Phase 1: Simple types (Text, URL, Email)
    _register(TextQrDefinition());
    _register(UrlQrDefinition());
    _register(EmailQrDefinition());

    // Phase 2: Remaining simple types
    _register(PhoneQrDefinition());
    _register(SmsQrDefinition());
    _register(LocationQrDefinition());
    _register(TwitterQrDefinition());
    _register(InstagramQrDefinition());

    // Phase 3: Complex types
    _register(WifiQrDefinition());
    _register(VCardQrDefinition());
    _register(BusinessQrDefinition());
    _register(EventQrDefinition());
  }

  /// Register a single QR type definition
  void _register(QrTypeDefinition definition) {
    if (_registry.containsKey(definition.type)) {
      throw StateError('QR type ${definition.type} is already registered');
    }
    _registry[definition.type] = definition;
  }

  /// Get definition for a specific QR type
  ///
  /// Returns null if the type is not registered.
  QrTypeDefinition? getDefinition(QRCodeType type) {
    return _registry[type];
  }

  /// Get all registered QR types
  List<QRCodeType> get supportedTypes => _registry.keys.toList();

  /// Check if a QR type is registered
  bool isSupported(QRCodeType type) => _registry.containsKey(type);

  /// Get localized display name for a QR type
  ///
  /// Returns empty string if type is not registered.
  String getDisplayName(QRCodeType type) {
    return _registry[type]?.displayName ?? '';
  }

  /// Get icon asset path for a QR type
  ///
  /// Returns empty string if type is not registered.
  String getIcon(QRCodeType type) {
    return _registry[type]?.icon ?? '';
  }

  /// Build form widget for a QR type
  ///
  /// Returns null if type is not registered.
  Widget? buildForm(QRCodeType type) {
    return _registry[type]?.buildForm();
  }

  /// Generate QR data from form data map
  ///
  /// Throws [Exception] if type is not registered.
  String generateQrData(QRCodeType type, Map<String, String> formDataMap) {
    final definition = _registry[type];
    if (definition == null) {
      throw Exception('Unknown QR type: $type');
    }

    final formData = definition.fromMap(formDataMap);
    return definition.generateQrData(formData);
  }

  /// Validate form data and return field errors
  ///
  /// Returns error map with 'error' key if type is not registered.
  Map<String, String> validateData(
    QRCodeType type,
    Map<String, String> formDataMap,
  ) {
    final definition = _registry[type];
    if (definition == null) {
      return {'error': 'Unknown QR type: $type'};
    }

    final formData = definition.fromMap(formDataMap);
    return definition.validateData(formData);
  }
}
