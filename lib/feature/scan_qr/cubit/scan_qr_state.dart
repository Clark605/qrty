part of 'scan_qr_cubit.dart';

class ScanQrState extends Equatable {
  final bool isFlashOn;
  final bool isFrontCamera;
  final double zoomLevel;
  final bool isScanning;
  final String? scannedData;
  final QRCodeType? scannedType;

  const ScanQrState({
    this.isFlashOn = false,
    this.isFrontCamera = false,
    this.zoomLevel = 0.0,
    this.isScanning = true,
    this.scannedData,
    this.scannedType,
  });

  ScanQrState copyWith({
    bool? isFlashOn,
    bool? isFrontCamera,
    double? zoomLevel,
    bool? isScanning,
    String? scannedData,
    QRCodeType? scannedType,
  }) {
    return ScanQrState(
      isFlashOn: isFlashOn ?? this.isFlashOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      isScanning: isScanning ?? this.isScanning,
      scannedData: scannedData ?? this.scannedData,
      scannedType: scannedType ?? this.scannedType,
    );
  }

  @override
  List<Object?> get props => [
    isFlashOn,
    isFrontCamera,
    zoomLevel,
    isScanning,
    scannedData,
    scannedType,
  ];
}
