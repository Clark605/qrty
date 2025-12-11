import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/feature/generate_qr/cubit/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/widgets/base_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/widgets/qr_form_field.dart';
import 'package:qrty/l10n/locale_keys.g.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';

/// Form screen for Contact (vCard) QR codes
class ContactQrFormScreen extends BaseQrFormScreen {
  const ContactQrFormScreen({super.key});

  @override
  String get formTitle => LocaleKeys.contact.tr();

  @override
  Widget buildFormFields(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    return Column(
      children: [
        // First Name
        QrFormField(
          label: LocaleKeys.first_name.tr(),
          hint: LocaleKeys.first_name_placeholder.tr(),
          fieldName: 'firstName',
          value: state.formData['firstName'],
          errorText: state.formErrors['firstName'],
          isRequired: true,
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Last Name
        QrFormField(
          label: LocaleKeys.last_name.tr(),
          hint: LocaleKeys.last_name_placeholder.tr(),
          fieldName: 'lastName',
          value: state.formData['lastName'],
          errorText: state.formErrors['lastName'],
          isRequired: true,
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Phone
        QrFormField(
          label: LocaleKeys.phone_number.tr(),
          hint: LocaleKeys.phone_placeholder.tr(),
          fieldName: 'phone',
          value: state.formData['phone'],
          errorText: state.formErrors['phone'],
          keyboardType: TextInputType.phone,
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Email
        QrFormField(
          label: LocaleKeys.email_address.tr(),
          hint: LocaleKeys.email_example_placeholder.tr(),
          fieldName: 'email',
          value: state.formData['email'],
          errorText: state.formErrors['email'],
          keyboardType: TextInputType.emailAddress,
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Company
        QrFormField(
          label: LocaleKeys.company.tr(),
          hint: LocaleKeys.company_placeholder.tr(),
          fieldName: 'company',
          value: state.formData['company'],
          errorText: state.formErrors['company'],
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Job Title
        QrFormField(
          label: LocaleKeys.job_title.tr(),
          hint: LocaleKeys.job_title_placeholder.tr(),
          fieldName: 'jobTitle',
          value: state.formData['jobTitle'],
          errorText: state.formErrors['jobTitle'],
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
    final firstName = formData['firstName']?.trim() ?? '';
    final lastName = formData['lastName']?.trim() ?? '';
    return firstName.isNotEmpty && lastName.isNotEmpty;
  }
}
