import 'package:flutter/material.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_type_registry.dart';

/// Factory class to create QR form screens based on QR type
///
/// Thin wrapper around QrTypeRegistry for backward compatibility.
/// All QR types are now managed through the registry system.
class QrFormScreenFactory {
  static final _registry = QrTypeRegistry();

  /// Create a form screen for the given QR type
  static Widget? createFormScreen(QRCodeType type) {
    return _registry.buildForm(type);
  }

  /// Check if a QR type has a form screen implemented
  static bool hasFormScreen(QRCodeType type) {
    return _registry.isSupported(type);
  }

  /// Get display name for QR type in navigation
  static String getDisplayName(QRCodeType type) {
    return _registry.getDisplayName(type);
  }
}
