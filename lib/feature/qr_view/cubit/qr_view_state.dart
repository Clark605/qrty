part of 'qr_view_cubit.dart';

class QrViewState extends Equatable {
  final bool showQrCode;

  const QrViewState({
    this.showQrCode = false,
  });

  QrViewState copyWith({
    bool? showQrCode,
  }) {
    return QrViewState(
      showQrCode: showQrCode ?? this.showQrCode,
    );
  }

  @override
  List<Object?> get props => [showQrCode];
}
