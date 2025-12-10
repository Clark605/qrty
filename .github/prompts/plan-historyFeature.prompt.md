# Plan: History Feature with ObjectBox Database

Implement a comprehensive QR code history tracking system with ObjectBox local database, featuring scan/generate history screens that match the exact UI design and automatically store QR interactions.

## Commits Structure

### Commit 1: Setup ObjectBox database and models
- Configure ObjectBox entity in `lib/core/models/qr_history_entity.dart` with `@Entity` annotation containing `id`, `data`, `type`, `source`, `timestamp` fields
- Create `lib/core/storage/objectbox_service.dart` singleton service with CRUD operations for QR history management
- Add ObjectBox initialization to `lib/main.dart` and provide store instance globally
- Run `flutter packages pub run build_runner build` to generate ObjectBox code

### Commit 2: Create history UI components
- Build `lib/feature/history/widgets/history_item.dart` matching the mockup design with QR icon, URL text, and date formatting
- Create `lib/feature/history/widgets/scan_create_tabs.dart` for "Scan" and "Create" tab buttons with yellow active state styling
- Implement `lib/feature/history/widgets/empty_history_state.dart` for when no history items exist
- Style components with `AppColors.primary` yellow theme and responsive sizing (`context.wp`, `context.hp`, `context.sp`)

### Commit 3: Build history state management
- Create `lib/feature/history/cubit/history_cubit.dart` with `HistoryState` containing `scanHistory`, `createHistory`, `isLoading`, `selectedTab` properties
- Implement methods: `loadHistory()`, `deleteHistoryItem()`, `clearAllHistory()`, `switchTab()`
- Use ObjectBoxService for data persistence and emit state changes for UI updates
- Follow existing Cubit patterns from `scan_qr_cubit.dart` and `settings_cubit.dart`

### Commit 4: Implement history screen
- Build `lib/feature/history/view/history_screen.dart` with `AppBackground` wrapper and tab-based layout
- Add AppBar with "History" title and optional clear actions
- Create tab content showing ListView of history items (no pull-to-refresh)
- Implement a delete icon on each history item to remove entries (match mockup)
- Handle empty states and loading indicators with proper error handling

### Commit 5: Wire history tracking to QR operations
- Update `lib/feature/scan_qr/cubit/scan_qr_cubit.dart` `onBarcodeDetected()` method to save scan history via ObjectBoxService
- Integrate history saving in QR generation feature when it's implemented
- Store data with `source: 'scan'` or `source: 'generate'` and current timestamp
- Handle duplicate detection and update existing entries if needed

### Commit 6: Replace app section placeholder and navigation
- Replace `Container(color: Colors.yellow)` at index 1 in `lib/feature/app_section/view/app_section.dart` with `BlocProvider` wrapping `HistoryScreen`
- Add history route case in `lib/core/routes/app_router.dart` using `AnimationRoute` with proper state management
- Update translations in `en.json`/`ar.json` for history-related text and add missing keys to `locale_keys.g.dart`
- Test navigation between Generate tab (index 0), History tab (index 1), and Scan tab (index 2)

