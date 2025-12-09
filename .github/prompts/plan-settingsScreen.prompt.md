# Plan: Settings Screen Implementation

Build a Settings screen with two sections (Settings & Support) featuring toggle switches for Vibrate/Beep and navigation items for Rate Us/Privacy Policy/Share, matching the exact UI design with clean architecture and state persistence.

## Commits Structure

### Commit 1: Add dependencies and setup services
- Add packages: `shared_preferences`, `vibration`, `audioplayers`
- Create `SettingsService` with SharedPreferences
- Create `FeedbackService` with vibration and sound
- Add beep sound asset

### Commit 2: Create settings state management
- Create `SettingsCubit` and `SettingsState`
- Implement settings methods (load, toggle)

### Commit 3: Build settings UI components
- Create `SettingsSectionHeader` widget
- Create `SettingsToggleItem` widget
- Create `SettingsNavigationItem` widget

### Commit 4: Implement settings screen
- Create `SettingsScreen` with UI layout
- Wire up cubit and toggle switches
- Add navigation handlers

### Commit 5: Integrate settings with router
- Add settings route to `AppRouter`
- Update app section navigation

### Commit 6: Wire feedback to scan QR feature
- Update `ScanQrCubit` to use `FeedbackService`
- Test feedback with different settings

## Steps

1. **Add Dependencies & Setup State Persistence**
   - Add `shared_preferences: ^2.3.4` to `pubspec.yaml` dependencies
   - Add `vibration: ^2.0.0` to `pubspec.yaml` for vibration feedback
   - Add `audioplayers: ^6.1.0` to `pubspec.yaml` for beep sound
   - Create `lib/core/services/settings_service.dart` to handle SharedPreferences operations (get/set vibrate and beep preferences)
   - Create `lib/core/services/feedback_service.dart` to handle vibration and sound playback using settings from SettingsService
   - Use singleton pattern for both services to maintain single instance across app
   - Add beep sound file (beep.mp3) to `assets/sounds/` directory and register in `pubspec.yaml`

2. **Create Settings State Management**
   - Create `lib/feature/settings/cubit/settings_cubit.dart` with `SettingsCubit` class
   - Create `lib/feature/settings/cubit/settings_state.dart` as `part of` cubit file with `isVibrateEnabled` and `isBeepEnabled` boolean properties
   - Implement methods: `loadSettings()`, `toggleVibrate()`, `toggleBeep()` that interact with SettingsService
   - Use Equatable for state comparison following existing cubit patterns in `scan_qr_cubit.dart` and `qr_view_cubit.dart`

3. **Build Settings UI Components**
   - Create `lib/feature/settings/widgets/settings_section_header.dart` widget for "Settings" and "Support" yellow text headers with `context.sp(20)` font size
   - Create `lib/feature/settings/widgets/settings_toggle_item.dart` with icon (SVG), title, subtitle, and yellow Switch widget using `AppAssets.vibrate`/`AppAssets.notification` icons
   - Create `lib/feature/settings/widgets/settings_navigation_item.dart` with icon, title, subtitle, and tap handler for Rate Us/Privacy Policy/Share items
   - Style with `AppColors.secondary` background, `AppColors.white` text, `AppColors.primary` for active states, using responsive sizing (`context.wp()`, `context.hp()`, `context.sp()`)

4. **Implement Settings Screen**
   - Build `lib/feature/settings/view/settings_screen.dart` with `AppBackground` wrapper and `BlocBuilder<SettingsCubit, SettingsState>`
   - Add AppBar with "Settings" title using `LocaleKeys.settings.tr()` and `AppColors.white`
   - Create ScrollView with two sections: Settings section (Vibrate toggle, Beep toggle with yellow dividers) and Support section (Rate Us, Privacy Policy, Share with yellow dividers)
   - Wire up toggle switches to `cubit.toggleVibrate()` and `cubit.toggleBeep()` methods
   - Implement navigation handlers: Rate Us , Privacy Policy , Share (placeholders for now)

5. **Integrate with Router & App**
   - Add settings route case in `lib/core/routes/app_router.dart` `generateRoute()` method using `AnimationRoute` with `BlocProvider` wrapping `SettingsScreen`
   - Update `lib/feature/app_section/view/app_section.dart` if settings button needs to be added to main navigation
   - Test navigation to settings screen from app section using `context.pushNamed(Routes.settings)`

6. **Wire Feedback to Scan QR Feature**
   - Update `lib/feature/scan_qr/cubit/scan_qr_cubit.dart`:
     - Import `FeedbackService`
     - In `onBarcodeDetected()` method, after detecting a valid barcode and before emitting state:
       ```dart
       await FeedbackService.instance.playFeedback();
       ```
     - This will check SettingsService for vibrate/beep preferences and trigger:
       * Vibration if `isVibrateEnabled` is true (using `Vibration.vibrate(duration: 200)`)
       * Beep sound if `isBeepEnabled` is true (using `AudioPlayer` to play beep.mp3)
   - FeedbackService logic:
     ```dart
     Future<void> playFeedback() async {
       final settings = await SettingsService.instance.getSettings();
       if (settings.isVibrateEnabled) {
         await Vibration.vibrate(duration: 200);
       }
       if (settings.isBeepEnabled) {
         await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
       }
     }
     ```
   - This ensures feedback happens immediately when QR is detected, respecting user preferences
   - Test with all combinations: vibrate only, beep only, both enabled, both disabled

## Further Considerations

1. **Beep Sound Asset** - Need to provide or generate a short beep sound file (beep.mp3 or beep.wav). Should be a quick, pleasant sound (300-500ms duration).

