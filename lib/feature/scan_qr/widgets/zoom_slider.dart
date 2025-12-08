import 'package:flutter/material.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/feature/scan_qr/cubit/scan_qr_cubit.dart';

class ZoomSlider extends StatelessWidget {
  const ZoomSlider({required this.cubit, required this.state, super.key});

  final ScanQrCubit cubit;
  final ScanQrState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.remove, color: AppColors.white, size: context.sp(24)),
        Expanded(
          child: Slider(
            value: state.zoomLevel,
            min: 0.0,
            max: 1.0,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.white.withOpacity(0.3),
            thumbColor: AppColors.primary,
            onChanged: cubit.updateZoom,
          ),
        ),
        Icon(Icons.add, color: AppColors.white, size: context.sp(24)),
      ],
    );
  }
}
