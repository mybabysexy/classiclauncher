import 'package:flutter/services.dart';

class LauncherUtils {
  static void doFeedback() {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
  }
}
