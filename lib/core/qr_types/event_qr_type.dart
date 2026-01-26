import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/qr_types/qr_form_data_base.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/core/utils/qr_generators.dart';
import 'package:qrty/feature/generate_qr/view/forms/complex/event_qr_form_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

// ============================================================================
// Form Data Model
// ============================================================================

/// Form data model for Event (iCal) QR codes
///
/// Represents event information following iCal/RFC 5545 standard with
/// summary, start/end dates, location, and description.
class EventQrFormData extends QrFormDataBase {
  final String summary;
  final String startDate; // ISO 8601 format string
  final String endDate; // ISO 8601 format string (optional)
  final String location;
  final String description;

  const EventQrFormData({
    required this.summary,
    required this.startDate,
    this.endDate = '',
    this.location = '',
    this.description = '',
  });

  /// Create from map (deserialization)
  factory EventQrFormData.fromMap(Map<String, String> map) {
    return EventQrFormData(
      summary: map['summary'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
    );
  }

  /// Create empty instance
  factory EventQrFormData.empty() =>
      EventQrFormData(summary: '', startDate: DateTime.now().toIso8601String());

  @override
  Map<String, String> toMap() => {
    'summary': summary,
    'startDate': startDate,
    'endDate': endDate,
    'location': location,
    'description': description,
  };

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};

    // Event title/summary is required
    if (summary.trim().isEmpty) {
      errors['summary'] = 'Event title is required';
    }

    // Start date is required
    if (startDate.trim().isEmpty) {
      errors['startDate'] = 'Start date is required';
    } else {
      // Validate start date format
      try {
        DateTime.parse(startDate);
      } catch (e) {
        errors['startDate'] = 'Invalid date format';
      }
    }

    // Validate end date format if provided
    if (endDate.trim().isNotEmpty) {
      try {
        final start = DateTime.parse(startDate);
        final end = DateTime.parse(endDate);

        // End date should be after start date
        if (end.isBefore(start)) {
          errors['endDate'] = 'End date must be after start date';
        }
      } catch (e) {
        errors['endDate'] = 'Invalid date format';
      }
    }

    return errors;
  }

  /// Copy with new values
  EventQrFormData copyWith({
    String? summary,
    String? startDate,
    String? endDate,
    String? location,
    String? description,
  }) {
    return EventQrFormData(
      summary: summary ?? this.summary,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      description: description ?? this.description,
    );
  }
}

// ============================================================================
// Type Definition
// ============================================================================

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
