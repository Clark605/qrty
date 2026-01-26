import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_type_registry.dart';

/// Unified QR content generator that handles all QR types
///
/// Thin wrapper around QrTypeRegistry for backward compatibility.
/// All generation and validation logic is now managed through the registry system.
class QrContentGenerator {
  static final _registry = QrTypeRegistry();

  /// Generate QR data based on type and form data
  static String generateQrData(QRCodeType type, Map<String, String> formData) {
    return _registry.generateQrData(type, formData);
  }

  /// Validate form data based on QR type
  static Map<String, String> validateFormData(
    QRCodeType type,
    Map<String, String> formData,
  ) {
    return _registry.validateData(type, formData);
  }
}
