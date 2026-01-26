import 'package:qrty/core/models/qr_form_data/qr_form_data_base.dart';

/// Form data model for text QR codes
///
/// Represents a simple text message to be encoded in a QR code.
class TextQrFormData extends QrFormDataBase {
  final String text;

  const TextQrFormData({required this.text});

  /// Create from map (deserialization)
  factory TextQrFormData.fromMap(Map<String, String> map) {
    return TextQrFormData(text: map['text'] ?? '');
  }

  /// Create empty instance
  factory TextQrFormData.empty() => const TextQrFormData(text: '');

  @override
  Map<String, String> toMap() => {'text': text};

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    if (text.trim().isEmpty) {
      errors['text'] = 'Text is required';
    }
    return errors;
  }

  /// Copy with new values
  TextQrFormData copyWith({String? text}) {
    return TextQrFormData(text: text ?? this.text);
  }
}
