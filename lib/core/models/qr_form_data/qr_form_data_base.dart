/// Base class for all QR form data models
///
/// Provides a contract for type-safe form data with validation and serialization.
/// Each QR type should extend this class to define its specific form fields.
abstract class QrFormDataBase {
  const QrFormDataBase();

  /// Convert form data to map for state management
  ///
  /// Used to serialize form data for storage in [GenerateQrState].
  Map<String, String> toMap();

  /// Validate form data and return field-level errors
  ///
  /// Returns a map where keys are field names and values are error messages.
  /// An empty map indicates valid data.
  Map<String, String> validate();

  /// Check if the form data is valid
  ///
  /// Returns true if [validate] returns an empty error map.
  bool get isValid => validate().isEmpty;
}
