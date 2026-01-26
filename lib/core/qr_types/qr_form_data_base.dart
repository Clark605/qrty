/// Base class for all QR form data models
///
/// Provides common interface for form data serialization and validation.
abstract class QrFormDataBase {
  const QrFormDataBase();

  /// Convert form data to map for state management
  Map<String, String> toMap();

  /// Validate form data and return error messages
  /// Returns empty map if validation passes
  Map<String, String> validate();

  /// Check if form data is valid
  bool get isValid => validate().isEmpty;
}
