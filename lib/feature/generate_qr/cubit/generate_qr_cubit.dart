import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/utils/history_helper.dart';
import 'package:qrty/core/utils/qr_content_generator.dart';

part 'generate_qr_state.dart';

class GenerateQrCubit extends Cubit<GenerateQrState> {
  GenerateQrCubit() : super(const GenerateQrState());

  // Select QR type from main grid
  void selectQrType(QRCodeType type) {
    emit(
      state.copyWith(
        selectedType: type,
        status: GenerateQrStatus.initial,
        formData: {},
        formErrors: {},
        generatedData: null,
        errorMessage: null,
      ),
    );
  }

  // Update form field data
  void updateFormField(String fieldName, String value) {
    final updatedFormData = Map<String, String>.from(state.formData);
    updatedFormData[fieldName] = value;

    // Clear error for this field if it exists
    final updatedErrors = Map<String, String?>.from(state.formErrors);
    updatedErrors.remove(fieldName);

    emit(state.copyWith(formData: updatedFormData, formErrors: updatedErrors));
  }

  // Validate form data based on QR type
  bool _validateForm() {
    if (state.selectedType == null) {
      return false;
    }

    final errors = QrContentGenerator.validateFormData(
      state.selectedType!,
      state.formData,
    );

    if (errors.isNotEmpty) {
      emit(state.copyWith(formErrors: errors));
      return false;
    }
    return true;
  }

  // Generate QR data based on type and form data
  String _generateQrData() {
    if (state.selectedType == null) {
      throw Exception('No QR type selected');
    }

    return QrContentGenerator.generateQrData(
      state.selectedType!,
      state.formData,
    );
  }

  // Generate QR code
  Future<void> generateQr() async {
    if (state.selectedType == null) {
      emit(
        state.copyWith(
          status: GenerateQrStatus.error,
          errorMessage: 'No QR type selected',
        ),
      );
      return;
    }

    if (!_validateForm()) {
      return;
    }

    emit(state.copyWith(status: GenerateQrStatus.generating));

    try {
      final qrData = _generateQrData();

      // Save to history
      await HistoryHelper.saveCreatedQr(
        data: qrData,
        type: state.selectedType!,
      );
      log('QR data saved to history: $qrData');
      emit(
        state.copyWith(status: GenerateQrStatus.success, generatedData: qrData),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GenerateQrStatus.error,
          errorMessage: 'Failed to generate QR code: ${e.toString()}',
        ),
      );
    }
  }

  // Reset to initial state
  void reset() {
    emit(const GenerateQrState());
  }
}
