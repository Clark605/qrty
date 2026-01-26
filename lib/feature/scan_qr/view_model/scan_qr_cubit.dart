import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';

import 'package:qrty/core/utils/qr_code_type_detector.dart';
import 'package:qrty/core/utils/qr_text_formatter.dart';
import 'package:qrty/feature/scan_qr/data/services/scan_service.dart';

part 'scan_qr_state.dart';

class ScanQrCubit extends Cubit<ScanQrState> {
  final ScanService scanService;

  ScanQrCubit({required this.scanService}) : super(const ScanQrState());

  void toggleFlash() {
    scanService.toggleFlash();
    emit(state.copyWith(isFlashOn: !state.isFlashOn));
  }

  void toggleCamera() {
    scanService.toggleCamera();
    emit(state.copyWith(isFrontCamera: !state.isFrontCamera));
  }

  void updateZoom(double value) {
    scanService.updateZoom(value);
    emit(state.copyWith(zoomLevel: value));
  }

  void onBarcodeDetected(BarcodeCapture barcodeCapture) async {
    if (!state.isScanning) return;

    final barcode = barcodeCapture.barcodes.firstOrNull;
    emit(state.copyWith(isScanning: false));
    scanService.onBarcodeDetected(barcodeCapture);
    final qrType = QRCodeTypeDetector.detectType(barcode!.rawValue!);
    final formattedText = QrTextFormatter.formatText(barcode.rawValue!, qrType);

    emit(
      state.copyWith(
        isScanning: false,
        scannedData: formattedText,
        scannedType: qrType,
      ),
    );
  }

  void resumeScanning() {
    emit(
      state.copyWith(isScanning: true, scannedData: null, scannedType: null),
    );
  }

  void pickImageFromGallery() async {
    final barcodes = await scanService.pickImageFromGallery();
    onBarcodeDetected(barcodes!);
  }
}
