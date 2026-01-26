import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/feature/generate_qr/view_model/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/view/widgets/base_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/widgets/qr_form_field.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Form screen for text QR codes
class TextQrFormScreen extends BaseQrFormScreen {
  const TextQrFormScreen({super.key});

  @override
  String get formTitle => LocaleKeys.text.tr();

  @override
  Widget buildFormFields(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    return QrFormField(
      label: LocaleKeys.text.tr(),
      hint: LocaleKeys.enter_text_placeholder.tr(),
      fieldName: 'text',
      value: state.formData['text'],
      errorText: state.formErrors['text'],
      maxLines: 5,
      isRequired: true,
      keyboardType: TextInputType.multiline,
      onChanged: cubit.updateFormField,
    );
  }

  @override
  bool isFormValid(Map<String, String> formData) {
    return formData['text']?.trim().isNotEmpty == true;
  }
}
