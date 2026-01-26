import 'package:qrty/core/models/qr_form_data/qr_form_data_base.dart';

/// Form data model for location QR codes
///
/// Represents a location/address to be encoded in a QR code.
class LocationQrFormData extends QrFormDataBase {
  final String location;

  const LocationQrFormData({required this.location});

  /// Create from map (deserialization)
  factory LocationQrFormData.fromMap(Map<String, String> map) {
    return LocationQrFormData(location: map['location'] ?? '');
  }

  /// Create empty instance
  factory LocationQrFormData.empty() => const LocationQrFormData(location: '');

  @override
  Map<String, String> toMap() => {'location': location};

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    if (location.trim().isEmpty) {
      errors['location'] = 'Location is required';
    }
    return errors;
  }

  /// Copy with new values
  LocationQrFormData copyWith({String? location}) {
    return LocationQrFormData(location: location ?? this.location);
  }
}
