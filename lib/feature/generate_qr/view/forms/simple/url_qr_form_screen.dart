import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/feature/generate_qr/view_model/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/view/widgets/base_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/widgets/qr_form_field.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Form screen for URL QR codes
class UrlQrFormScreen extends BaseQrFormScreen {
  const UrlQrFormScreen({super.key});

  @override
  String get formTitle => LocaleKeys.website.tr();

  @override
  Widget buildFormFields(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    return QrFormField(
      label: LocaleKeys.website_url.tr(),
      hint: LocaleKeys.website_placeholder.tr(),
      fieldName: 'url',
      value: state.formData['url'],
      errorText: state.formErrors['url'],
      isRequired: true,
      keyboardType: TextInputType.url,
      onChanged: cubit.updateFormField,
    );
  }

  @override
  bool isFormValid(Map<String, String> formData) {
    final url = formData['url']?.trim() ?? '';
    return url.isNotEmpty && _isValidUrl(url);
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}
