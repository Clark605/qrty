import 'package:flutter/material.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';

/// Abstract definition for QR type behavior
///
/// Each QR type (Text, URL, WiFi, etc.) has a concrete implementation of this class
/// that defines how to:
/// - Display the type (name and icon)
/// - Create and validate form data
/// - Build the form UI
/// - Generate QR code data
///
/// This provides a plugin-like architecture where new QR types can be added
/// without modifying existing code (Open/Closed Principle).
abstract class QrTypeDefinition<T extends QrFormDataBase> {
  /// The QR type enum value this definition handles
  QRCodeType get type;

  /// Localized display name for UI
  String get displayName;

  /// Asset path for the type's icon
  String get icon;

  /// Create an empty instance of the form data
  T createEmpty();

  /// Create form data from a map (deserialization)
  T fromMap(Map<String, String> map);

  /// Build the form widget for this QR type
  ///
  /// Context parameter is optional and can be used for future enhancements
  /// like dependency injection or theme access.
  Widget buildForm([BuildContext? context]);

  /// Generate QR code data string from typed form data
  String generateQrData(T formData);

  /// Validate typed form data and return field errors
  Map<String, String> validateData(T formData);
}
