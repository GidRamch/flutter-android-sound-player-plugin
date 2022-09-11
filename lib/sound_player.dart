import 'package:sound_player/models/channel_type.dart';
import 'package:sound_player/sound_player_platform_interface.dart';

class SoundPlayer {
  Future<String?> getPlatformVersion() {
    return SoundPlayerPlatform.instance.getPlatformVersion();
  }

  Future<void> playSound(
    Channel ringtoneChannel,
    Channel volumeChannel,
  ) async {
    await SoundPlayerPlatform.instance.playSound(
      ringtoneChannel,
      volumeChannel,
    );
  }

  Future<void> playCustomSound(
    String uriString,
    Channel volumeChannel,
    String packageName,
  ) async {
    await SoundPlayerPlatform.instance.playCustomSound(
      uriString,
      volumeChannel,
      packageName,
    );
  }

  Future<void> stopSound() async {
    await SoundPlayerPlatform.instance.stopSound();
  }
}
