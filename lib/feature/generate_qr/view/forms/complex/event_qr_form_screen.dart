import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/feature/generate_qr/cubit/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/widgets/base_qr_form_screen.dart';
import 'package:qrty/feature/generate_qr/widgets/qr_form_field.dart';
import 'package:qrty/l10n/locale_keys.g.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';

/// Form screen for Event QR codes
class EventQrFormScreen extends BaseQrFormScreen {
  const EventQrFormScreen({super.key});

  @override
  String get formTitle => LocaleKeys.event.tr();

  @override
  Widget buildFormFields(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  ) {
    return Column(
      children: [
        // Event Title
        QrFormField(
          label: LocaleKeys.event_title.tr(),
          hint: LocaleKeys.event_title_placeholder.tr(),
          fieldName: 'title',
          value: state.formData['title'],
          errorText: state.formErrors['title'],
          isRequired: true,
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Event Description
        QrFormField(
          label: LocaleKeys.event_description.tr(),
          hint: LocaleKeys.event_description_placeholder.tr(),
          fieldName: 'description',
          value: state.formData['description'],
          errorText: state.formErrors['description'],
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Event Location
        QrFormField(
          label: LocaleKeys.event_location.tr(),
          hint: LocaleKeys.event_location_placeholder.tr(),
          fieldName: 'location',
          value: state.formData['location'],
          errorText: state.formErrors['location'],
          onChanged: cubit.updateFormField,
        ),

        SizedBox(height: context.hp(2)),

        // Start Date
        _buildDateTimeField(
          context,
          cubit,
          state,
          LocaleKeys.start_date.tr(),
          'startDate',
          isDate: true,
        ),

        SizedBox(height: context.hp(2)),

        // Start Time
        _buildDateTimeField(
          context,
          cubit,
          state,
          LocaleKeys.start_time.tr(),
          'startTime',
          isDate: false,
        ),

        SizedBox(height: context.hp(2)),

        // End Date
        _buildDateTimeField(
          context,
          cubit,
          state,
          LocaleKeys.end_date.tr(),
          'endDate',
          isDate: true,
        ),

        SizedBox(height: context.hp(2)),

        // End Time
        _buildDateTimeField(
          context,
          cubit,
          state,
          LocaleKeys.end_time.tr(),
          'endTime',
          isDate: false,
        ),
      ],
    );
  }

  Widget _buildDateTimeField(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
    String label,
    String fieldName, {
    required bool isDate,
  }) {
    final currentValue = state.formData[fieldName] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: context.hp(0.8)),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: state.formErrors[fieldName] != null
                  ? AppColors.error
                  : AppColors.inputBorder,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _selectDateTime(
                context,
                cubit,
                fieldName,
                currentValue,
                isDate,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.wp(4),
                  vertical: context.hp(1.8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentValue.isEmpty
                            ? (isDate ? 'Select date' : 'Select time')
                            : currentValue,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: currentValue.isEmpty
                              ? AppColors.bodyGrey
                              : AppColors.white,
                        ),
                      ),
                    ),
                    Icon(
                      isDate ? Icons.calendar_today : Icons.access_time,
                      color: AppColors.bodyGrey,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (state.formErrors[fieldName] != null)
          Padding(
            padding: EdgeInsets.only(top: context.hp(0.5)),
            child: Text(
              state.formErrors[fieldName]!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }

  Future<void> _selectDateTime(
    BuildContext context,
    GenerateQrCubit cubit,
    String fieldName,
    String currentValue,
    bool isDate,
  ) async {
    if (isDate) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _parseDate(currentValue) ?? DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
                surface: AppColors.secondary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        cubit.updateFormField(fieldName, formattedDate);
      }
    } else {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _parseTime(currentValue) ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
                surface: AppColors.secondary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null && context.mounted) {
        final formattedTime = picked.format(context);
        cubit.updateFormField(fieldName, formattedTime);
      }
    }
  }

  DateTime? _parseDate(String dateString) {
    if (dateString.isEmpty) return null;
    try {
      return DateFormat('yyyy-MM-dd').parse(dateString);
    } catch (e) {
      return null;
    }
  }

  TimeOfDay? _parseTime(String timeString) {
    if (timeString.isEmpty) return null;
    try {
      final format = DateFormat.jm();
      final dateTime = format.parse(timeString);
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } catch (e) {
      return null;
    }
  }

  @override
  bool isFormValid(Map<String, String> formData) {
    final title = formData['title']?.trim() ?? '';
    return title.isNotEmpty;
  }
}
