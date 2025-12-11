import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:qrty/core/utils/qr_code_image_generator.dart';
import 'package:share_plus/share_plus.dart';

part 'qr_view_state.dart';

class QrViewCubit extends Cubit<QrViewState> {
  QrViewCubit() : super(const QrViewState());

  void toggleView() {
    emit(state.copyWith(showQrCode: !state.showQrCode));
  }

  void copyToClipboard(String data, BuildContext context) {
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void shareData(String data) {
    SharePlus.instance.share(ShareParams(text: data));
  }

  Future<void> saveQrCode(String data, BuildContext context) async {
    try {
      // Emit loading state
      emit(state.copyWith(isSaving: true));

      // Generate QR code image using utility class
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

        // Emit success state
        emit(state.copyWith(isSaving: false));

        if (result['isSuccess'] == true && context.mounted) {
          _showSuccessMessage(context, 'QR code saved to gallery');
        } else if (context.mounted) {
          _showErrorMessage(context, 'Failed to save QR code');
        }
      } else {
        emit(state.copyWith(isSaving: false));
        if (context.mounted) {
          _showErrorMessage(context, 'Failed to generate QR code image');
        }
      }
    } catch (e) {
      emit(state.copyWith(isSaving: false));
      if (context.mounted) {
        _showErrorMessage(context, 'Error saving QR code: ${e.toString()}');
      }
    }
  }

  void _showSuccessMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
