import 'package:objectbox/objectbox.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';

@Entity()
class QrHistoryEntity {
  @Id()
  int id = 0;

  String data;
  int typeIndex; // Store enum index for ObjectBox compatibility
  String source; // 'scan' or 'generate'
  
  @Property(type: PropertyType.date)
  DateTime timestamp;

  QrHistoryEntity({
    required this.data,
    required this.typeIndex,
    required this.source,
    required this.timestamp,
  });

  // Helper getters and setters for QRCodeType enum
  QRCodeType get type => QRCodeType.values[typeIndex];
  set type(QRCodeType qrType) => typeIndex = qrType.index;

  // Convert to/from QRCodeType for easy usage
  factory QrHistoryEntity.fromQRCodeType({
    required String data,
    required QRCodeType type,
    required String source,
    required DateTime timestamp,
  }) {
    return QrHistoryEntity(
      data: data,
      typeIndex: type.index,
      source: source,
      timestamp: timestamp,
    );
  }
}