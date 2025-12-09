import 'package:audioplayers/audioplayers.dart';
import 'package:qrty/core/services/settings_service.dart';
import 'package:vibration/vibration.dart';

class FeedbackService {
  FeedbackService._internal() {
    _audioPlayer = AudioPlayer();
  }
  static final FeedbackService instance = FeedbackService._internal();

  late AudioPlayer _audioPlayer;

  /// Play feedback (vibration and/or beep) based on user settings
  Future<void> playFeedback() async {
    try {
      final settings = await SettingsService.instance.getSettings();

      // Play vibration if enabled
      if (settings.isVibrateEnabled) {
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true) {
          await Vibration.vibrate(duration: 200);
        }
      }

      // Play beep sound if enabled
      if (settings.isBeepEnabled) {
        await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
      }
    } catch (e) {
      // Handle errors silently to not disrupt user experience
    }
  }

  /// Dispose audio player resources
  void dispose() {
    _audioPlayer.dispose();
  }
}
