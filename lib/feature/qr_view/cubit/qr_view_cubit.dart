import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void saveQrCode() {
    // TODO: Implement save QR code to gallery
    // Will need image_gallery_saver or similar package
  }
}
