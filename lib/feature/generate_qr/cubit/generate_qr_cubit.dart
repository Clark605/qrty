import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/utils/history_helper.dart';

part 'generate_qr_state.dart';

class GenerateQrCubit extends Cubit<GenerateQrState> {
  GenerateQrCubit() : super(const GenerateQrState());

  // Select QR type from main grid
  void selectQrType(QRCodeType type) {
    emit(
      state.copyWith(
        selectedType: type,
        status: GenerateQrStatus.initial,
        formData: {},
        formErrors: {},
        generatedData: null,
        errorMessage: null,
      ),
    );
  }

  // Update form field data
  void updateFormField(String fieldName, String value) {
    final updatedFormData = Map<String, String>.from(state.formData);
    updatedFormData[fieldName] = value;

    // Clear error for this field if it exists
    final updatedErrors = Map<String, String?>.from(state.formErrors);
    updatedErrors.remove(fieldName);

    emit(state.copyWith(formData: updatedFormData, formErrors: updatedErrors));
  }

  // Validate form data based on QR type
  bool _validateForm() {
    final errors = <String, String>{};
    final formData = state.formData;

    switch (state.selectedType) {
      case QRCodeType.text:
        if (formData['text']?.trim().isEmpty ?? true) {
          errors['text'] = 'Text is required';
        }
        break;
      case QRCodeType.url:
        final url = formData['url']?.trim() ?? '';
        if (url.isEmpty) {
          errors['url'] = 'URL is required';
        } else if (!_isValidUrl(url)) {
          errors['url'] = 'Please enter a valid URL';
        }
        break;
      case QRCodeType.email:
        final email = formData['email']?.trim() ?? '';
        if (email.isEmpty) {
          errors['email'] = 'Email is required';
        } else if (!_isValidEmail(email)) {
          errors['email'] = 'Please enter a valid email';
        }
        break;
      case QRCodeType.phone:
        if (formData['phone']?.trim().isEmpty ?? true) {
          errors['phone'] = 'Phone number is required';
        }
        break;
      case QRCodeType.wifi:
        if (formData['ssid']?.trim().isEmpty ?? true) {
          errors['ssid'] = 'Network name is required';
        }
        if (formData['security'] != 'OPEN' &&
            (formData['password']?.trim().isEmpty ?? true)) {
          errors['password'] = 'Password is required for secured networks';
        }
        break;
      case QRCodeType.vcard:
        if ((formData['firstName']?.trim().isEmpty ?? true) &&
            (formData['lastName']?.trim().isEmpty ?? true)) {
          errors['firstName'] = 'At least first or last name is required';
        }
        break;
      case QRCodeType.event:
        if (formData['summary']?.trim().isEmpty ?? true) {
          errors['summary'] = 'Event name is required';
        }
        if (formData['startDate']?.trim().isEmpty ?? true) {
          errors['startDate'] = 'Start date is required';
        }
        break;
      case QRCodeType.business:
        if (formData['company']?.trim().isEmpty ?? true) {
          errors['company'] = 'Company name is required';
        }
        break;
      case QRCodeType.twitter:
        if (formData['handle']?.trim().isEmpty ?? true) {
          errors['handle'] = 'Twitter handle is required';
        }
        break;
      case QRCodeType.instagram:
        if (formData['handle']?.trim().isEmpty ?? true) {
          errors['handle'] = 'Instagram handle is required';
        }
        break;
      case QRCodeType.location:
        if (formData['location']?.trim().isEmpty ?? true) {
          errors['location'] = 'Location is required';
        }
        break;
      case QRCodeType.sms:
        if (formData['phone']?.trim().isEmpty ?? true) {
          errors['phone'] = 'Phone number is required';
        }
        break;
      default:
        break;
    }

    if (errors.isNotEmpty) {
      emit(state.copyWith(formErrors: errors));
      return false;
    }
    return true;
  }

  // Generate QR data based on type and form data
  String _generateQrData() {
    final formData = state.formData;

    switch (state.selectedType!) {
      case QRCodeType.text:
        return formData['text'] ?? '';
      case QRCodeType.url:
        final url = formData['url'] ?? '';
        return url.startsWith('http') ? url : 'https://$url';
      case QRCodeType.email:
        return 'mailto:${formData['email']}';
      case QRCodeType.phone:
        return 'tel:${formData['phone']}';
      case QRCodeType.wifi:
        final ssid = formData['ssid'] ?? '';
        final password = formData['password'] ?? '';
        final security = formData['security'] ?? 'WPA';
        return 'WIFI:T:$security;S:$ssid;P:$password;;';
      case QRCodeType.vcard:
        return _generateVCard();
      case QRCodeType.event:
        return _generateEvent();
      case QRCodeType.business:
        return _generateBusinessCard();
      case QRCodeType.twitter:
        final handle = formData['handle'] ?? '';
        return 'https://twitter.com/${handle.replaceFirst('@', '')}';
      case QRCodeType.instagram:
        final handle = formData['handle'] ?? '';
        return 'https://instagram.com/${handle.replaceFirst('@', '')}';
      case QRCodeType.location:
        return formData['location'] ?? '';
      case QRCodeType.sms:
        final phone = formData['phone'] ?? '';
        final message = formData['message'] ?? '';
        return message.isEmpty ? 'sms:$phone' : 'sms:$phone?body=$message';
    }
  }

  // Generate vCard format
  String _generateVCard() {
    final formData = state.formData;
    final vcard = StringBuffer();
    vcard.writeln('BEGIN:VCARD');
    vcard.writeln('VERSION:3.0');

    final firstName = formData['firstName'] ?? '';
    final lastName = formData['lastName'] ?? '';
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      vcard.writeln('FN:$firstName $lastName'.trim());
      vcard.writeln('N:$lastName;$firstName;;;');
    }

    if (formData['company']?.isNotEmpty ?? false) {
      vcard.writeln('ORG:${formData['company']}');
    }
    if (formData['job']?.isNotEmpty ?? false) {
      vcard.writeln('TITLE:${formData['job']}');
    }
    if (formData['phone']?.isNotEmpty ?? false) {
      vcard.writeln('TEL:${formData['phone']}');
    }
    if (formData['email']?.isNotEmpty ?? false) {
      vcard.writeln('EMAIL:${formData['email']}');
    }
    if (formData['website']?.isNotEmpty ?? false) {
      vcard.writeln('URL:${formData['website']}');
    }
    if (formData['address']?.isNotEmpty ?? false) {
      vcard.writeln(
        'ADR:;;${formData['address']};${formData['city']};${formData['state']};${formData['zip']};${formData['country']}',
      );
    }

    vcard.writeln('END:VCARD');
    return vcard.toString();
  }

  // Generate event format (basic iCal)
  String _generateEvent() {
    final formData = state.formData;
    final event = StringBuffer();
    event.writeln('BEGIN:VCALENDAR');
    event.writeln('VERSION:2.0');
    event.writeln('BEGIN:VEVENT');

    if (formData['summary']?.isNotEmpty ?? false) {
      event.writeln('SUMMARY:${formData['summary']}');
    }
    if (formData['startDate']?.isNotEmpty ?? false) {
      event.writeln('DTSTART:${formData['startDate']}');
    }
    if (formData['endDate']?.isNotEmpty ?? false) {
      event.writeln('DTEND:${formData['endDate']}');
    }
    if (formData['location']?.isNotEmpty ?? false) {
      event.writeln('LOCATION:${formData['location']}');
    }
    if (formData['description']?.isNotEmpty ?? false) {
      event.writeln('DESCRIPTION:${formData['description']}');
    }

    event.writeln('END:VEVENT');
    event.writeln('END:VCALENDAR');
    return event.toString();
  }

  // Generate business card (vCard with business focus)
  String _generateBusinessCard() {
    final formData = state.formData;
    final businessCard = StringBuffer();
    businessCard.writeln('BEGIN:VCARD');
    businessCard.writeln('VERSION:3.0');

    if (formData['company']?.isNotEmpty ?? false) {
      businessCard.writeln('ORG:${formData['company']}');
      businessCard.writeln('FN:${formData['company']}');
    }
    if (formData['industry']?.isNotEmpty ?? false) {
      businessCard.writeln('CATEGORIES:${formData['industry']}');
    }
    if (formData['phone']?.isNotEmpty ?? false) {
      businessCard.writeln('TEL:${formData['phone']}');
    }
    if (formData['email']?.isNotEmpty ?? false) {
      businessCard.writeln('EMAIL:${formData['email']}');
    }
    if (formData['website']?.isNotEmpty ?? false) {
      businessCard.writeln('URL:${formData['website']}');
    }
    if (formData['address']?.isNotEmpty ?? false) {
      businessCard.writeln(
        'ADR:;;${formData['address']};${formData['city']};${formData['state']};${formData['zip']};${formData['country']}',
      );
    }

    businessCard.writeln('END:VCARD');
    return businessCard.toString();
  }

  // Generate QR code
  Future<void> generateQr() async {
    if (state.selectedType == null) {
      emit(
        state.copyWith(
          status: GenerateQrStatus.error,
          errorMessage: 'No QR type selected',
        ),
      );
      return;
    }

    if (!_validateForm()) {
      return;
    }

    emit(state.copyWith(status: GenerateQrStatus.generating));

    try {
      final qrData = _generateQrData();

      // Save to history
      await HistoryHelper.saveCreatedQr(
        data: qrData,
        type: state.selectedType!,
      );

      emit(
        state.copyWith(status: GenerateQrStatus.success, generatedData: qrData),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GenerateQrStatus.error,
          errorMessage: 'Failed to generate QR code: ${e.toString()}',
        ),
      );
    }
  }

  // Reset to initial state
  void reset() {
    emit(const GenerateQrState());
  }

  // Validation helpers
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url.contains('://') ? url : 'https://$url');
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
