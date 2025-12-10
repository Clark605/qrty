import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/feature/generate_qr/cubit/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/widgets/base_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/widgets/qr_form_field.dart';
import 'package:qrty/l10n/locale_keys.g.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';

/// Form screen for Business QR codes
class BusinessQrFormScreen extends BaseQrFormScreen {
  const BusinessQrFormScreen({super.key});

  @override
  String get formTitle => LocaleKeys.business.tr();

  @override
  Widget buildFormFields(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    return Column(
      children: [
        // Business Name
        QrFormField(
          label: LocaleKeys.business_name.tr(),
          hint: LocaleKeys.business_name_placeholder.tr(),
          fieldName: 'company',
          value: state.formData['company'],
          errorText: state.formErrors['company'],
          isRequired: true,
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Industry
        QrFormField(
          label: LocaleKeys.industry.tr(),
          hint: LocaleKeys.industry_placeholder.tr(),
          fieldName: 'industry',
          value: state.formData['industry'],
          errorText: state.formErrors['industry'],
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Business Phone
        QrFormField(
          label: LocaleKeys.business_phone.tr(),
          hint: LocaleKeys.business_phone_placeholder.tr(),
          fieldName: 'phone',
          value: state.formData['phone'],
          errorText: state.formErrors['phone'],
          keyboardType: TextInputType.phone,
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Business Email
        QrFormField(
          label: LocaleKeys.business_email.tr(),
          hint: LocaleKeys.business_email_placeholder.tr(),
          fieldName: 'email',
          value: state.formData['email'],
          errorText: state.formErrors['email'],
          keyboardType: TextInputType.emailAddress,
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Business Website
        QrFormField(
          label: LocaleKeys.business_website.tr(),
          hint: LocaleKeys.business_website_placeholder.tr(),
          fieldName: 'website',
          value: state.formData['website'],
          errorText: state.formErrors['website'],
          keyboardType: TextInputType.url,
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Address
        QrFormField(
          label: LocaleKeys.address.tr(),
          hint: LocaleKeys.address_placeholder_contact.tr(),
          fieldName: 'address',
          value: state.formData['address'],
          errorText: state.formErrors['address'],
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // City
        QrFormField(
          label: LocaleKeys.city.tr(),
          hint: LocaleKeys.city_placeholder.tr(),
          fieldName: 'city',
          value: state.formData['city'],
          errorText: state.formErrors['city'],
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // State
        QrFormField(
          label: LocaleKeys.state.tr(),
          hint: LocaleKeys.state_placeholder.tr(),
          fieldName: 'state',
          value: state.formData['state'],
          errorText: state.formErrors['state'],
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // ZIP Code
        QrFormField(
          label: LocaleKeys.zip_code.tr(),
          hint: LocaleKeys.zip_placeholder.tr(),
          fieldName: 'zip',
          value: state.formData['zip'],
          errorText: state.formErrors['zip'],
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Country
        QrFormField(
          label: LocaleKeys.country.tr(),
          hint: LocaleKeys.country_placeholder.tr(),
          fieldName: 'country',
          value: state.formData['country'],
          errorText: state.formErrors['country'],
          onChanged: cubit.updateFormField,
        ),
      ],
    );
  }

  @override
  bool isFormValid(Map<String, String> formData) {
    final company = formData['company']?.trim() ?? '';
    return company.isNotEmpty;
  }
}
