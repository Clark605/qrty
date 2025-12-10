import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/feature/generate_qr/cubit/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/widgets/base_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/widgets/qr_form_field.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Form screen for location QR codes
class LocationQrFormScreen extends BaseQrFormScreen {
  const LocationQrFormScreen({super.key});

  @override
  String get formTitle => LocaleKeys.location.tr();

  @override
  Widget buildFormFields(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    return QrFormField(
      label: LocaleKeys.location.tr(),
      hint: LocaleKeys.address_placeholder.tr(),
      fieldName: 'location',
      value: state.formData['location'],
      errorText: state.formErrors['location'],
      isRequired: true,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      onChanged: cubit.updateFormField,
    );
  }

  @override
  bool isFormValid(Map<String, String> formData) {
    final location = formData['location']?.trim() ?? '';
    return location.isNotEmpty;
  }
}
