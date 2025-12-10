import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/feature/generate_qr/cubit/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/widgets/base_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/widgets/qr_form_field.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Form screen for Twitter QR codes
class TwitterQrFormScreen extends BaseQrFormScreen {
  const TwitterQrFormScreen({super.key});

  @override
  String get formTitle => LocaleKeys.twitter.tr();

  @override
  Widget buildFormFields(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    return QrFormField(
      label: LocaleKeys.twitter_handle.tr(),
      hint: LocaleKeys.handle_placeholder.tr(),
      fieldName: 'handle',
      value: state.formData['handle'],
      errorText: state.formErrors['handle'],
      isRequired: true,
      keyboardType: TextInputType.text,
      onChanged: cubit.updateFormField,
    );
  }

  @override
  bool isFormValid(Map<String, String> formData) {
    final handle = formData['handle']?.trim() ?? '';
    return handle.isNotEmpty && _isValidHandle(handle);
  }

  bool _isValidHandle(String handle) {
    // Remove @ if present
    final cleanHandle = handle.replaceFirst('@', '');

    // Check if it's a valid Twitter username (alphanumeric and underscore only, 1-15 chars)
    final handleRegex = RegExp(r'^[a-zA-Z0-9_]{1,15}$');
    return handleRegex.hasMatch(cleanHandle);
  }
}
