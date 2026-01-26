import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/dialogs/app_dialogs.dart';
import 'package:qrty/feature/qr_view/data/services/view_service.dart';

part 'qr_view_state.dart';

class QrViewCubit extends Cubit<QrViewState> {
  final ViewService viewService;
  QrViewCubit(this.viewService) : super(const QrViewState());

  void toggleView() {
    emit(state.copyWith(showQrCode: !state.showQrCode));
  }

  void copyToClipboard(String data, BuildContext context) {
    viewService.copyToClipboard(data, context);
  }

  void shareData(String data) {
    viewService.shareData(data);
  }

  Future<void> saveQrCode(String data, BuildContext context) async {
    try {
      // Emit loading state
      emit(state.copyWith(isSaving: true));

      final result = await viewService.saveQrCode(data, context);

      // Emit success state
      emit(state.copyWith(isSaving: false));

      if (result == true && context.mounted) {
        AppDialogs.showSuccessMessage(context, 'QR code saved to gallery');
      } else if (context.mounted) {
        AppDialogs.showErrorMessage(context, 'Failed to save QR code');
      } else {
        emit(state.copyWith(isSaving: false));
        if (context.mounted) {
          AppDialogs.showErrorMessage(
            context,
            'Failed to generate QR code image',
          );
        }
      }
    } catch (e) {
      emit(state.copyWith(isSaving: false));
      if (context.mounted) {
        AppDialogs.showErrorMessage(
          context,
          'Error saving QR code: ${e.toString()}',
        );
      }
    }
  }
}
