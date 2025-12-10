import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/core/utils/type_icon.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

class QrTypeItem extends StatelessWidget {
  final QRCodeType type;
  final VoidCallback onTap;

  const QrTypeItem({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff3C3C3C),
          borderRadius: BorderRadius.circular(context.wp(2)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(TypeIcon.typeIcon(type), height: context.wp(6.5)),
            SizedBox(height: context.hp(0.5)),
            Text(
              _getTypeName(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontSize: context.sp(12),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeName() {
    switch (type) {
      case QRCodeType.text:
        return LocaleKeys.text.tr();
      case QRCodeType.url:
        return LocaleKeys.website.tr();
      case QRCodeType.wifi:
        return LocaleKeys.wifi.tr();
      case QRCodeType.event:
        return LocaleKeys.event.tr();
      case QRCodeType.vcard:
        return LocaleKeys.contact.tr();
      case QRCodeType.business:
        return LocaleKeys.business.tr();
      case QRCodeType.location:
        return LocaleKeys.location.tr();
      case QRCodeType.email:
        return LocaleKeys.email.tr();
      case QRCodeType.phone:
        return LocaleKeys.telephone.tr();
      case QRCodeType.twitter:
        return LocaleKeys.twitter.tr();
      case QRCodeType.instagram:
        return LocaleKeys.instagram.tr();
      case QRCodeType.sms:
        return LocaleKeys.whatsapp.tr(); // Using WhatsApp label for SMS for now
    }
  }
}
