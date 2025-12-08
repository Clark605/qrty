import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrty/core/routes/routes.dart';

part 'scan_qr_state.dart';

class ScanQrCubit extends Cubit<ScanQrState> {
  final MobileScannerController scannerController;
  final BuildContext context;

  ScanQrCubit({
    required this.scannerController,
    required this.context,
  }) : super(const ScanQrState());

  void toggleFlash() {
    scannerController.toggleTorch();
    emit(state.copyWith(isFlashOn: !state.isFlashOn));
  }

  void toggleCamera() {
    scannerController.switchCamera();
    emit(state.copyWith(isFrontCamera: !state.isFrontCamera));
  }

  void updateZoom(double value) {
    scannerController.setZoomScale(value);
    emit(state.copyWith(zoomLevel: value));
  }

  void onBarcodeDetected(BarcodeCapture barcodeCapture) {
    if (!state.isScanning) return;

    final barcode = barcodeCapture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    emit(state.copyWith(isScanning: false));

    Navigator.pushNamed(
      context,
      Routes.qrView,
      arguments: {
        'data': barcode!.rawValue!,
        'timestamp': DateTime.now(),
        'source': 'scan',
      },
    ).then((_) {
      // Re-enable scanning when returning
      emit(state.copyWith(isScanning: true));
    });
  }

  void pickImageFromGallery() async {
    // TODO: Implement image picker and QR code detection from image
  }

  @override
  Future<void> close() {
    scannerController.dispose();
    return super.close();
  }
}
