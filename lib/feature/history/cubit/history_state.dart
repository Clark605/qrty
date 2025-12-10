part of 'history_cubit.dart';

enum HistoryTab { scan, create }

class HistoryState extends Equatable {
  final List<QrHistoryEntity> scanHistory;
  final List<QrHistoryEntity> createHistory;
  final bool isLoading;
  final HistoryTab selectedTab;

  const HistoryState({
    this.scanHistory = const [],
    this.createHistory = const [],
    this.isLoading = false,
    this.selectedTab = HistoryTab.scan,
  });

  HistoryState copyWith({
    List<QrHistoryEntity>? scanHistory,
    List<QrHistoryEntity>? createHistory,
    bool? isLoading,
    HistoryTab? selectedTab,
  }) {
    return HistoryState(
      scanHistory: scanHistory ?? this.scanHistory,
      createHistory: createHistory ?? this.createHistory,
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  // Get currently displayed history based on selected tab
  List<QrHistoryEntity> get currentHistory {
    return selectedTab == HistoryTab.scan ? scanHistory : createHistory;
  }

  @override
  List<Object?> get props => [
    scanHistory,
    createHistory,
    isLoading,
    selectedTab,
  ];
}
