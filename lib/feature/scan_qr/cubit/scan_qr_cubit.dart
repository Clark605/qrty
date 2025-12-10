import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/services/feedback_service.dart';
import 'package:qrty/core/utils/history_helper.dart';
import 'package:qrty/core/utils/qr_code_type_detector.dart';
import 'package:qrty/core/utils/qr_text_formatter.dart';

part 'scan_qr_state.dart';

class ScanQrCubit extends Cubit<ScanQrState> {
  final MobileScannerController scannerController;

  ScanQrCubit({required this.scannerController}) : super(const ScanQrState());

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

  void onBarcodeDetected(BarcodeCapture barcodeCapture) async {
    if (!state.isScanning) return;

    final barcode = barcodeCapture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    emit(state.copyWith(isScanning: false));

    // Play feedback based on user settings
    await FeedbackService.instance.playFeedback();

    final qrType = QRCodeTypeDetector.detectType(barcode!.rawValue!);
    final formattedText = QrTextFormatter.formatText(barcode.rawValue!, qrType);

    // Save to history
    await _saveToHistory(barcode.rawValue!, qrType);

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
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage == null) return;
    final barcodes = await scannerController.analyzeImage(pickedImage.path);
    onBarcodeDetected(barcodes!);
  }

  Future<void> _saveToHistory(String data, QRCodeType type) async {
    await HistoryHelper.saveScannedQr(data: data, type: type);
  }

  @override
  Future<void> close() {
    scannerController.dispose();
    return super.close();
  }
}
