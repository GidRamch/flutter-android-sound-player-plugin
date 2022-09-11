import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sound_player/models/channel_type.dart';

import 'sound_player_method_channel.dart';

abstract class SoundPlayerPlatform extends PlatformInterface {
  /// Constructs a SoundPlayerPlatform.
  SoundPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static SoundPlayerPlatform _instance = MethodChannelSoundPlayer();

  /// The default instance of [SoundPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelSoundPlayer].
  static SoundPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SoundPlayerPlatform] when
  /// they register themselves.
  static set instance(SoundPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> playSound(
    Channel ringtoneChannel,
    Channel volumeChannel,
  ) async {
    throw UnimplementedError('playSound() has not been implemented.');
  }

  Future<void> stopSound() async {
    throw UnimplementedError('playSound() has not been implemented.');
  }
}
