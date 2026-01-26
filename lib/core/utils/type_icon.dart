import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_type_registry.dart';

/// Provides icon assets for QR code types
///
/// Thin wrapper around QrTypeRegistry for backward compatibility.
/// All icon mappings are now managed through the registry system.
abstract class TypeIcon {
  static final _registry = QrTypeRegistry();

  /// Get the asset path for a QR type's icon
  static String typeIcon(QRCodeType type) {
    return _registry.getIcon(type);
  }
}
