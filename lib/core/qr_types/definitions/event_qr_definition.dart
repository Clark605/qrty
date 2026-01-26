import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/event_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/qr_data_generators/ical_generator.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/event_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Definition for Event QR type
///
/// Handles calendar event QR codes following iCal/RFC 5545 standard
/// with summary, start/end dates, location, and description.
class EventQrDefinition extends QrTypeDefinition<EventQrFormData> {
  @override
  QRCodeType get type => QRCodeType.event;

  @override
  String get displayName => LocaleKeys.event.tr();

  @override
  String get icon => AppAssets.event;

  @override
  EventQrFormData createEmpty() => EventQrFormData.empty();

  @override
  EventQrFormData fromMap(Map<String, String> map) {
    return EventQrFormData.fromMap(map);
  }

  @override
  Widget buildForm([BuildContext? context]) {
    return const EventQrFormScreen();
  }

  @override
  String generateQrData(EventQrFormData formData) {
    final startDate = DateTime.parse(formData.startDate);
    final endDate = formData.endDate.isNotEmpty
        ? DateTime.parse(formData.endDate)
        : null;

    return ICalGenerator.generateEvent(
      summary: formData.summary,
      startDate: startDate,
      endDate: endDate,
      location: formData.location.isNotEmpty ? formData.location : null,
      description: formData.description.isNotEmpty
          ? formData.description
          : null,
    );
  }

  @override
  Map<String, String> validateData(EventQrFormData formData) {
    return formData.validate();
  }
}
