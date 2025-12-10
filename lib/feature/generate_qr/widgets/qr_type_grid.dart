import 'package:flutter/material.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/feature/generate_qr/widgets/qr_type_item.dart';

class QrTypeGrid extends StatelessWidget {
  final Function(QRCodeType) onTypeSelected;

  const QrTypeGrid({super.key, required this.onTypeSelected});

  // QR types in the order shown in mockups
  static const List<QRCodeType> _qrTypes = [
    QRCodeType.text,
    QRCodeType.url,
    QRCodeType.wifi,
    QRCodeType.event,
    QRCodeType.vcard,
    QRCodeType.business,
    QRCodeType.location,
    QRCodeType.sms, // WhatsApp will use SMS for now
    QRCodeType.email,
    QRCodeType.twitter,
    QRCodeType.instagram,
    QRCodeType.phone,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.wp(5)),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: context.wp(11),
          mainAxisSpacing: context.wp(11),
        ),
        itemCount: _qrTypes.length,
        itemBuilder: (context, index) {
          final type = _qrTypes[index];
          return QrTypeItem(type: type, onTap: () => onTypeSelected(type));
        },
      ),
    );
  }
}
