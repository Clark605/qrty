import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/core/utils/type_icon.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

class QrResultView extends StatefulWidget {
  final String data;
  final DateTime timestamp;
  final bool showQrCode;
  final VoidCallback onToggleView;
  final QRCodeType type;

  const QrResultView({
    super.key,
    required this.data,
    required this.timestamp,
    required this.showQrCode,
    required this.onToggleView,
    required this.type,
  });

  @override
  State<QrResultView> createState() => _QrResultViewState();
}

class _QrResultViewState extends State<QrResultView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: context.wp(4.4),
        vertical: context.hp(1.9),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: context.wp(5),
        vertical: context.hp(2),
      ),
      decoration: BoxDecoration(
        color: Color(0xff3C3C3C),
        borderRadius: BorderRadius.circular(context.wp(0.6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            spacing: context.wp(3),
            children: [
              SvgPicture.asset(
                TypeIcon.typeIcon(widget.type),
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.type.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    DateFormat.yMMMd().add_jm().format(widget.timestamp),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          Divider(
            color: AppColors.white.withOpacity(0.3),
            height: context.hp(4),
          ),
          Text(
            widget.data,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.white),
            textAlign: TextAlign.start,
          ),
          TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(
                AppColors.primary.withOpacity(0.1),
              ),
            ),
            onPressed: widget.onToggleView,
            child: Text(
              widget.showQrCode
                  ? LocaleKeys.show_qr_code.tr()
                  : LocaleKeys.text.tr(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.primary),
            ),
          ),
          widget.showQrCode
              ? SizedBox.shrink()
              : QrImageView(
                  data: widget.data,
                  version: QrVersions.auto,
                  size: context.wp(60),
                  backgroundColor: AppColors.white,
                ),
        ],
      ),
    );
  }
}
