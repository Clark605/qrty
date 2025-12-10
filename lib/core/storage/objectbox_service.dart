import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_history_entity.dart';
import 'objectbox.g.dart';

class ObjectBoxService {
  static ObjectBoxService? _instance;
  late Store _store;
  late Box<QrHistoryEntity> _historyBox;

  ObjectBoxService._internal();

  static ObjectBoxService get instance {
    _instance ??= ObjectBoxService._internal();
    return _instance!;
  }

  // Initialize with store (called from main.dart)
  void initializeWithStore(Store store) {
    _store = store;
    _historyBox = _store.box<QrHistoryEntity>();
  }

  // Save QR history entry
  Future<void> saveQrHistory({
    required String data,
    required QRCodeType type,
    required String source,
  }) async {
    // Check for duplicate entries (same data and source)
    final existing = _historyBox
        .query(
          QrHistoryEntity_.data.equals(data) &
              QrHistoryEntity_.source.equals(source),
        )
        .build()
        .find();

    if (existing.isNotEmpty) {
      // Update timestamp for existing entry
      final entry = existing.first;
      entry.timestamp = DateTime.now();
      _historyBox.put(entry);
    } else {
      // Create new entry
      final historyEntry = QrHistoryEntity.fromQRCodeType(
        data: data,
        type: type,
        source: source,
        timestamp: DateTime.now(),
      );
      _historyBox.put(historyEntry);
    }
  }

  // Get scan history (ordered by timestamp desc)
  List<QrHistoryEntity> getScanHistory() {
    return _historyBox
        .query(QrHistoryEntity_.source.equals('scan'))
        .order(QrHistoryEntity_.timestamp, flags: Order.descending)
        .build()
        .find();
  }

  // Get generate history (ordered by timestamp desc)
  List<QrHistoryEntity> getGenerateHistory() {
    return _historyBox
        .query(QrHistoryEntity_.source.equals('generate'))
        .order(QrHistoryEntity_.timestamp, flags: Order.descending)
        .build()
        .find();
  }

  // Get all history entries
  List<QrHistoryEntity> getAllHistory() {
    return _historyBox
        .query()
        .order(QrHistoryEntity_.timestamp, flags: Order.descending)
        .build()
        .find();
  }

  // Delete specific history entry
  Future<void> deleteHistoryItem(int id) async {
    _historyBox.remove(id);
  }

  // Clear all scan history
  Future<void> clearScanHistory() async {
    final scanEntries = _historyBox
        .query(QrHistoryEntity_.source.equals('scan'))
        .build()
        .find();

    for (final entry in scanEntries) {
      _historyBox.remove(entry.id);
    }
  }

  // Clear all generate history
  Future<void> clearGenerateHistory() async {
    final generateEntries = _historyBox
        .query(QrHistoryEntity_.source.equals('generate'))
        .build()
        .find();

    for (final entry in generateEntries) {
      _historyBox.remove(entry.id);
    }
  }

  // Clear all history
  Future<void> clearAllHistory() async {
    _historyBox.removeAll();
  }

  // Get history count for source
  int getHistoryCount(String source) {
    return _historyBox
        .query(QrHistoryEntity_.source.equals(source))
        .build()
        .count();
  }

  // Close the store
  void close() {
    _store.close();
  }
}
