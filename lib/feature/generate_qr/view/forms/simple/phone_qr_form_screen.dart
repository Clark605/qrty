import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/feature/generate_qr/cubit/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/widgets/base_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/widgets/qr_form_field.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Form screen for phone QR codes
class PhoneQrFormScreen extends BaseQrFormScreen {
  const PhoneQrFormScreen({super.key});

  @override
  String get formTitle => LocaleKeys.telephone.tr();

  @override
  Widget buildFormFields(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    return QrFormField(
      label: LocaleKeys.phone_number.tr(),
      hint: LocaleKeys.phone_placeholder.tr(),
      fieldName: 'phone',
      value: state.formData['phone'],
      errorText: state.formErrors['phone'],
      isRequired: true,
      keyboardType: TextInputType.phone,
      onChanged: cubit.updateFormField,
    );
  }

  @override
  bool isFormValid(Map<String, String> formData) {
    final phone = formData['phone']?.trim() ?? '';
    return phone.isNotEmpty && _isValidPhone(phone);
  }

  bool _isValidPhone(String phone) {
    // Check if it contains only digits (and optionally starts with +)
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }
}
