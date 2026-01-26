part of 'generate_qr_cubit.dart';

enum GenerateQrStatus { initial, generating, success, error }

class GenerateQrState extends Equatable {
  final GenerateQrStatus status;
  final QRCodeType? selectedType;
  final String? generatedData;
  final Map<String, String> formData;
  final Map<String, String?> formErrors;
  final String? errorMessage;

  const GenerateQrState({
    this.status = GenerateQrStatus.initial,
    this.selectedType,
    this.generatedData,
    this.formData = const {},
    this.formErrors = const {},
    this.errorMessage,
  });

  GenerateQrState copyWith({
    GenerateQrStatus? status,
    QRCodeType? selectedType,
    String? generatedData,
    Map<String, String>? formData,
    Map<String, String?>? formErrors,
    String? errorMessage,
  }) {
    return GenerateQrState(
      status: status ?? this.status,
      selectedType: selectedType ?? this.selectedType,
      generatedData: generatedData ?? this.generatedData,
      formData: formData ?? this.formData,
      formErrors: formErrors ?? this.formErrors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedType,
    generatedData,
    formData,
    formErrors,
    errorMessage,
  ];
}
