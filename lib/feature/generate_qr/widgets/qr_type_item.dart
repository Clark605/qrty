import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/core/utils/type_icon.dart';
import 'package:qrty/core/qr_types/qr_type_registry.dart';

class QrTypeItem extends StatelessWidget {
  final QRCodeType type;
  final VoidCallback onTap;

  const QrTypeItem({super.key, required this.type, required this.onTap});

  static final _registry = QrTypeRegistry();

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
              _registry.getDisplayName(type),
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
}
