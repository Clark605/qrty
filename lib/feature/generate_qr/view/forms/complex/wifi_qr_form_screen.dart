import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/feature/generate_qr/view_model/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/view/widgets/base_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/view/widgets/qr_form_field.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Form screen for Wi-Fi QR codes
class WifiQrFormScreen extends BaseQrFormScreen {
  const WifiQrFormScreen({super.key});

  @override
  String get formTitle => LocaleKeys.wifi.tr();

  @override
  Widget buildFormFields(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    return Column(
      children: [
        // Network Name (SSID)
        QrFormField(
          label: LocaleKeys.network_name.tr(),
          hint: LocaleKeys.ssid_placeholder.tr(),
          fieldName: 'ssid',
          value: state.formData['ssid'],
          errorText: state.formErrors['ssid'],
          isRequired: true,
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Password
        QrFormField(
          label: LocaleKeys.wifi_password.tr(),
          hint: LocaleKeys.wifi_password_placeholder.tr(),
          fieldName: 'password',
          value: state.formData['password'],
          errorText: state.formErrors['password'],
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Security Type Dropdown
        _buildSecurityTypeDropdown(context, cubit, state),

        SizedBox(height: context.hp(2)),

        // Hidden Network Switch
        _buildHiddenNetworkSwitch(context, cubit, state),
      ],
    );
  }

  Widget _buildSecurityTypeDropdown(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    final securityTypes = ['WPA', 'WEP', 'Open'];
    final currentValue = state.formData['security'] ?? 'WPA';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.security_type.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: context.hp(0.8)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: context.wp(4)),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: state.formErrors['security'] != null
                  ? AppColors.error
                  : AppColors.inputBorder,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              isExpanded: true,
              dropdownColor: AppColors.secondary,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.white),
              items: securityTypes.map((String type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  cubit.updateFormField('security', newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHiddenNetworkSwitch(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    final isHidden = state.formData['hidden'] == 'true';

    return Row(
      children: [
        Expanded(
          child: Text(
            LocaleKeys.hidden_network.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Switch(
          value: isHidden,
          onChanged: (bool value) {
            cubit.updateFormField('hidden', value.toString());
          },
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }

  @override
  bool isFormValid(Map<String, String> formData) {
    final ssid = formData['ssid']?.trim() ?? '';
    return ssid.isNotEmpty;
  }
}
