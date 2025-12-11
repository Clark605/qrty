import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/services/feedback_service.dart';
import 'package:qrty/core/utils/history_helper.dart';
import 'package:qrty/core/utils/qr_code_type_detector.dart';

class ScanService {
  final MobileScannerController scannerController = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
    returnImage: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  void toggleFlash() {
    scannerController.toggleTorch();
  }

  void toggleCamera() {
    scannerController.switchCamera();
  }

  void updateZoom(double value) {
    scannerController.setZoomScale(value);
  }

  Future<void> onBarcodeDetected(BarcodeCapture barcodeCapture) async {
    final barcode = barcodeCapture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;
    // Play feedback based on user settings
    await FeedbackService.instance.playFeedback();

    final qrType = QRCodeTypeDetector.detectType(barcode!.rawValue!);
    // Save to history
    await _saveToHistory(barcode.rawValue!, qrType);
  }

  Future<BarcodeCapture?> pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage == null) return null;
    final barcodes = await scannerController.analyzeImage(pickedImage.path);
    return barcodes;
  }

  Future<void> _saveToHistory(String data, QRCodeType type) async {
    await HistoryHelper.saveScannedQr(data: data, type: type);
  }
}
