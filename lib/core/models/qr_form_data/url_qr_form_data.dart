import 'package:qrty/core/models/qr_form_data/qr_form_data_base.dart';
import 'package:qrty/core/utils/validators.dart';

/// Form data model for URL QR codes
///
/// Represents a website URL to be encoded in a QR code.
class UrlQrFormData extends QrFormDataBase {
  final String url;

  const UrlQrFormData({required this.url});

  /// Create from map (deserialization)
  factory UrlQrFormData.fromMap(Map<String, String> map) {
    return UrlQrFormData(url: map['url'] ?? '');
  }

  /// Create empty instance
  factory UrlQrFormData.empty() => const UrlQrFormData(url: '');

  @override
  Map<String, String> toMap() => {'url': url};

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    final trimmedUrl = url.trim();

    if (trimmedUrl.isEmpty) {
      errors['url'] = 'URL is required';
    } else if (!UrlValidator.isValid(trimmedUrl)) {
      errors['url'] = 'Please enter a valid URL';
    }

    return errors;
  }

  /// Copy with new values
  UrlQrFormData copyWith({String? url}) {
    return UrlQrFormData(url: url ?? this.url);
  }
}
