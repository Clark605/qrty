import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/models/qr_history_entity.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/core/utils/type_icon.dart';

class HistoryItem extends StatelessWidget {
  final QrHistoryEntity historyItem;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const HistoryItem({
    super.key,
    required this.historyItem,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.wp(4),
        vertical: context.hp(0.5),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(4),
        vertical: context.hp(1.5),
      ),
      decoration: BoxDecoration(
        color: const Color(0xff3C3C3C),
        borderRadius: BorderRadius.circular(context.wp(3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.wp(3)),
        child: Row(
          children: [
            // QR Code Type Icon
            Container(
              padding: EdgeInsets.all(context.wp(2.5)),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(context.wp(2)),
              ),
              child: SvgPicture.asset(
                TypeIcon.typeIcon(historyItem.type),
                width: context.wp(8),
                height: context.wp(8),
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),

            SizedBox(width: context.wp(3)),

            // Content (URL/Data and Date)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // URL/Data Text
                  Text(
                    historyItem.data,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: context.hp(0.3)),

                  // Date and Source
                  Text(
                    _formatDate(historyItem.timestamp),
                    style: TextStyle(
                      color: AppColors.bodyGrey,
                      fontSize: context.sp(12),
                    ),
                  ),
                ],
              ),
            ),

            // Delete Button
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: EdgeInsets.all(context.wp(2)),
                child: SvgPicture.asset(
                  AppAssets.delete,
                  width: context.wp(5),
                  height: context.wp(5),
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      // Same day - show time only
      return DateFormat('h:mm a').format(date);
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // Within a week - show day name
      return DateFormat('EEEE').format(date);
    } else {
      // Older than a week - show date
      return DateFormat('dd MMM yyyy, h:mm a').format(date);
    }
  }
}
