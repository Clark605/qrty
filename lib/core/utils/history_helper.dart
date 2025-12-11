import 'dart:developer';

import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/storage/objectbox_service.dart';

/// Helper class for QR history operations
class HistoryHelper {
  /// Save scanned QR code to history
  static Future<void> saveScannedQr({
    required String data,
    required QRCodeType type,
  }) async {
    try {
      await ObjectBoxService.instance.saveQrHistory(
        data: data,
        type: type,
        source: 'scan',
      );
    } catch (e) {
      // Log error but don't break the flow
      log('Error saving scanned QR to history: $e');
    }
  }

  /// Save generated/created QR code to history
  static Future<void> saveCreatedQr({
    required String data,
    required QRCodeType type,
  }) async {
    try {
      await ObjectBoxService.instance.saveQrHistory(
        data: data,
        type: type,
        source: 'generate',
      );
    } catch (e) {
      // Log error but don't break the flow
      log('Error saving created QR to history: $e');
    }
  }
}
