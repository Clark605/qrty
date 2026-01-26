import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_type_registry.dart';

abstract class TypeIcon {
  static final _registry = QrTypeRegistry();

  static String typeIcon(QRCodeType type) {
    // Try registry first (Phase 1: Text, URL, Email)
    if (_registry.isSupported(type)) {
      return _registry.getIcon(type);
    }

    // Fallback to legacy switch for unmigrated types
    switch (type) {
      case QRCodeType.url:
        return AppAssets.website;
      case QRCodeType.wifi:
        return AppAssets.wifi;
      case QRCodeType.email:
        return AppAssets.email;
      case QRCodeType.phone:
        return AppAssets.telephone;
      case QRCodeType.sms:
        return AppAssets.telephone;
      case QRCodeType.vcard:
        return AppAssets.contact;
      case QRCodeType.location:
        return AppAssets.location;
      case QRCodeType.event:
        return AppAssets.event;
      case QRCodeType.business:
        return AppAssets.business;
      case QRCodeType.twitter:
        return AppAssets.twitter;
      case QRCodeType.instagram:
        return AppAssets.instagram;
      default:
        return AppAssets.text;
    }
  }
}
