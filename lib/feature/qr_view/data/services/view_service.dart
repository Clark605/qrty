import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:qrty/core/dialogs/app_dialogs.dart';
import 'package:qrty/core/utils/qr_code_image_generator.dart';
import 'package:share_plus/share_plus.dart';

class ViewService {
  void copyToClipboard(String data, BuildContext context) {
    Clipboard.setData(ClipboardData(text: data));
    AppDialogs.showSuccessMessage(context, 'Copied to clipboard');
  }

  void shareData(String data) {
    SharePlus.instance.share(ShareParams(text: data));
  }

  Future<bool?> saveQrCode(String data, BuildContext context) async {
    final pngBytes = await QrCodeImageGenerator.generateQrImageBytes(
      data: data,
      size: 512,
    );

    if (pngBytes != null) {
      // Save to gallery
      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        name: "QR_Code_${DateTime.now().millisecondsSinceEpoch}",
        quality: 100,
      );
      return result['isSuccess'] == true;
    }
    return null;
  }
}
