import 'dart:developer';

import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/utils/history_helper.dart';
import 'package:qrty/core/utils/qr_content_generator.dart';

/// Service layer for QR code generation business logic
///
/// Handles validation, generation, and persistence of QR codes.
/// This service encapsulates all business logic related to QR generation,
/// keeping the view model thin and focused on state management.
class GenerateService {
  /// Validates form data for a specific QR type
  ///
  /// Returns a map of field names to error messages.
  /// Empty map means validation passed.
  Map<String, String?> validateFormData(
    QRCodeType type,
    Map<String, String> formData,
  ) {
    return QrContentGenerator.validateFormData(type, formData);
  }

  /// Generates QR data string from form data
  ///
  /// Throws [Exception] if QR type is invalid or data is malformed.
  String generateQrData(QRCodeType type, Map<String, String> formData) {
    return QrContentGenerator.generateQrData(type, formData);
  }

  /// Saves generated QR code to history
  ///
  /// Persists the QR data and metadata to ObjectBox database.
  Future<void> saveToHistory({
    required String data,
    required QRCodeType type,
  }) async {
    await HistoryHelper.saveCreatedQr(data: data, type: type);
    log('QR data saved to history: $data');
  }
}
