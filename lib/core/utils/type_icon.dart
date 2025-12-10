import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';

abstract class TypeIcon {
  static String typeIcon(QRCodeType type) {
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
