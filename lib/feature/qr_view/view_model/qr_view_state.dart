part of 'qr_view_cubit.dart';

class QrViewState extends Equatable {
  final bool showQrCode;
  final bool isSaving;

  const QrViewState({this.showQrCode = false, this.isSaving = false});

  QrViewState copyWith({bool? showQrCode, bool? isSaving}) {
    return QrViewState(
      showQrCode: showQrCode ?? this.showQrCode,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [showQrCode, isSaving];
}
