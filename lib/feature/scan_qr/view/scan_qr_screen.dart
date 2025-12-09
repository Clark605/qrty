import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/extensions/navigator_extensions.dart';
import 'package:qrty/core/routes/routes.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/feature/scan_qr/cubit/scan_qr_cubit.dart';
import 'package:qrty/feature/scan_qr/widgets/conrtol_button.dart';
import 'package:qrty/feature/scan_qr/widgets/qr_scanner_overlay.dart';
import 'package:qrty/feature/scan_qr/widgets/zoom_slider.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ScanQrCubit(scannerController: MobileScannerController()),
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: BlocListener<ScanQrCubit, ScanQrState>(
          listener: (context, state) {
            if (state.scannedData != null && state.scannedType != null) {
              context
                  .pushNamed(
                    Routes.qrView,
                    arguments: {
                      'data': state.scannedData!,
                      'timestamp': DateTime.now(),
                      'source': 'scan',
                      'type': state.scannedType!,
                    },
                  )
                  .then((_) {
                    context.read<ScanQrCubit>().resumeScanning();
                  });
            }
          },
          child: BlocBuilder<ScanQrCubit, ScanQrState>(
            builder: (contexts, state) {
              final cubit = contexts.read<ScanQrCubit>();

              return Stack(
                children: [
                  // Camera Scanner
                  MobileScanner(
                    controller: cubit.scannerController,
                    onDetect: cubit.onBarcodeDetected,
                  ),

                  // Overlay with corner brackets
                  const QRScannerOverlay(),

                  // Top Control Bar
                  SafeArea(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        left: context.wp(15),
                        right: context.wp(15),
                        top: context.hp(2),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(context.wp(6)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ControlButton(
                            icon: AppAssets.images,
                            onTap: cubit.pickImageFromGallery,
                          ),
                          ControlButton(
                            icon: AppAssets.flash,
                            onTap: cubit.toggleFlash,
                            isActive: state.isFlashOn,
                          ),
                          ControlButton(
                            icon: AppAssets.flipCamera,
                            onTap: cubit.toggleCamera,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Zoom Slider
                  Positioned(
                    bottom: context.hp(10),
                    left: context.wp(10),
                    right: context.wp(10),
                    child: ZoomSlider(cubit: cubit, state: state),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
