import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/models/qr_history_entity.dart';
import 'package:qrty/core/storage/objectbox_service.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final ObjectBoxService _objectBoxService;

  HistoryCubit({ObjectBoxService? objectBoxService})
    : _objectBoxService = objectBoxService ?? ObjectBoxService.instance,
      super(const HistoryState());

  // Load history data from ObjectBox
  Future<void> loadHistory() async {
    emit(state.copyWith(isLoading: true));

    try {
      final scanHistory = _objectBoxService.getScanHistory();
      final createHistory = _objectBoxService.getGenerateHistory();

      emit(
        state.copyWith(
          scanHistory: scanHistory,
          createHistory: createHistory,
          isLoading: false,
        ),
      );
    } catch (e) {
      // Handle error gracefully
      emit(state.copyWith(isLoading: false));
    }
  }

  // Switch between scan and create tabs
  void switchTab(HistoryTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  // Delete a specific history item
  Future<void> deleteHistoryItem(int id) async {
    try {
      await _objectBoxService.deleteHistoryItem(id);

      // Reload history to reflect changes
      await loadHistory();
    } catch (e) {
      // Handle error gracefully - could emit error state if needed
    }
  }

  // Clear all scan history
  Future<void> clearScanHistory() async {
    try {
      await _objectBoxService.clearScanHistory();

      // Update state immediately for better UX
      emit(state.copyWith(scanHistory: []));
    } catch (e) {
      // Handle error gracefully
    }
  }

  // Clear all create/generate history
  Future<void> clearCreateHistory() async {
    try {
      await _objectBoxService.clearGenerateHistory();

      // Update state immediately for better UX
      emit(state.copyWith(createHistory: []));
    } catch (e) {
      // Handle error gracefully
    }
  }

  // Clear all history (both scan and create)
  Future<void> clearAllHistory() async {
    try {
      await _objectBoxService.clearAllHistory();

      // Update state immediately for better UX
      emit(state.copyWith(scanHistory: [], createHistory: []));
    } catch (e) {
      // Handle error gracefully
    }
  }

  // Refresh history data (useful for pull-to-refresh if added later)
  Future<void> refreshHistory() async {
    await loadHistory();
  }

  // Get count for specific tab
  int getHistoryCount(HistoryTab tab) {
    return tab == HistoryTab.scan
        ? state.scanHistory.length
        : state.createHistory.length;
  }

  // Check if current tab has any history
  bool get hasHistory {
    return state.currentHistory.isNotEmpty;
  }

  // Check if scan history is empty
  bool get isScanHistoryEmpty {
    return state.scanHistory.isEmpty;
  }

  // Check if create history is empty
  bool get isCreateHistoryEmpty {
    return state.createHistory.isEmpty;
  }
}
