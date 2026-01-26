import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/feature/generate_qr/view_model/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/view/widgets/base_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/widgets/qr_form_field.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Form screen for email QR codes
class EmailQrFormScreen extends BaseQrFormScreen {
  const EmailQrFormScreen({super.key});

  @override
  String get formTitle => LocaleKeys.email.tr();

  @override
  Widget buildFormFields(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    return Column(
      children: [
        QrFormField(
          label: LocaleKeys.email_address.tr(),
          hint: LocaleKeys.email_example_placeholder.tr(),
          fieldName: 'email',
          value: state.formData['email'],
          errorText: state.formErrors['email'],
          isRequired: true,
          keyboardType: TextInputType.emailAddress,
          onChanged: cubit.updateFormField,
        ),

        QrFormField(
          label: LocaleKeys.subject.tr(),
          hint: LocaleKeys.email_subject_optional.tr(),
          fieldName: 'subject',
          value: state.formData['subject'],
          errorText: state.formErrors['subject'],
          onChanged: cubit.updateFormField,
        ),

        QrFormField(
          label: LocaleKeys.message.tr(),
          hint: LocaleKeys.email_message_optional.tr(),
          fieldName: 'body',
          value: state.formData['body'],
          errorText: state.formErrors['body'],
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onChanged: cubit.updateFormField,
        ),
      ],
    );
  }

  @override
  bool isFormValid(Map<String, String> formData) {
    final email = formData['email']?.trim() ?? '';
    return email.isNotEmpty && _isValidEmail(email);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&'
      '*+/=?^_`{|}~-]+'
      r'@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
      r'(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );
    return emailRegex.hasMatch(email);
  }
}
