import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Utility class for generating QR code images
class QrCodeImageGenerator {
  /// Generates a QR code image as bytes
  ///
  /// [data] - The data to encode in the QR code
  /// [size] - The size of the generated image (default: 512x512)
  /// [foregroundColor] - The color of the QR code modules (default: black)
  /// [backgroundColor] - The background color of the image (default: white)
  ///
  /// Returns the image as PNG bytes or null if generation fails
  static Future<Uint8List?> generateQrImageBytes({
    required String data,
    double size = 512,
    Color foregroundColor = const Color(0xFF000000),
    Color backgroundColor = const Color(0xFFFFFFFF),
  }) async {
    try {
      // Validate QR code data
      final qrValidationResult = QrValidator.validate(
        data: data,
        version: QrVersions.auto,
      );

      if (qrValidationResult.status != QrValidationStatus.valid) {
        return null;
      }

      final qrCode = qrValidationResult.qrCode!;
      final painter = QrPainter.withQr(
        qr: qrCode,
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: foregroundColor,
        ),
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: foregroundColor,
        ),
        gapless: false,
      );

      // Create a picture recorder
      final pictureRecorder = ui.PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      final imageSize = Size(size, size);

      // Fill background
      canvas.drawRect(
        Rect.fromLTWH(0, 0, imageSize.width, imageSize.height),
        Paint()..color = backgroundColor,
      );

      // Paint the QR code
      painter.paint(canvas, imageSize);

      // Convert to image
      final picture = pictureRecorder.endRecording();
      final image = await picture.toImage(
        imageSize.width.toInt(),
        imageSize.height.toInt(),
      );
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  /// Generates a QR code image as a Flutter Image widget
  ///
  /// [data] - The data to encode in the QR code
  /// [size] - The size of the generated image (default: 512x512)
  /// [foregroundColor] - The color of the QR code modules (default: black)
  /// [backgroundColor] - The background color of the image (default: white)
  ///
  /// Returns a Future<Image?> widget or null if generation fails
  static Future<Image?> generateQrImageWidget({
    required String data,
    double size = 512,
    Color foregroundColor = const Color(0xFF000000),
    Color backgroundColor = const Color(0xFFFFFFFF),
  }) async {
    final imageBytes = await generateQrImageBytes(
      data: data,
      size: size,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );

    if (imageBytes == null) {
      return null;
    }

    return Image.memory(
      imageBytes,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  /// Validates if the provided data can be encoded as a QR code
  ///
  /// [data] - The data to validate
  ///
  /// Returns true if the data can be encoded, false otherwise
  static bool isValidQrData(String data) {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
    );
    return qrValidationResult.status == QrValidationStatus.valid;
  }
}
