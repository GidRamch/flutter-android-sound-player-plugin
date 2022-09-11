import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sound_player/models/channel_type.dart';

import 'sound_player_platform_interface.dart';

/// An implementation of [SoundPlayerPlatform] that uses method channels.
class MethodChannelSoundPlayer extends SoundPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sound_player');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> playCustomSound(
    String uriString,
    Channel volumeChannel,
    String packageName,
  ) async {
    if (volumeChannel == Channel.Alarm) {
      await methodChannel.invokeMethod<String>('playCustomSound_Alarm', {
        'uriString': uriString,
        'packageName': packageName,
      });
    } else if (volumeChannel == Channel.Notification) {
      await methodChannel.invokeMethod<String>('playCustomSound_Notification', {
        'uriString': uriString,
        'packageName': packageName,
      });
    } else if (volumeChannel == Channel.Media) {
      await methodChannel.invokeMethod<String>('playCustomSound_Media', {
        uriString: uriString,
        packageName: packageName,
      });
    }
  }

  @override
  Future<void> playSound(
    Channel ringtoneChannel,
    Channel volumeChannel,
  ) async {
    if (volumeChannel == Channel.Ringtone) {
      if (ringtoneChannel == Channel.Ringtone) {
        await methodChannel
            .invokeMethod<String>('playRingtone_RingtoneChannel');
      } else if (ringtoneChannel == Channel.Notification) {
        await methodChannel
            .invokeMethod<String>('playNotification_RingtoneChannel');
      } else {
        await methodChannel.invokeMethod<String>('playAlarm_RingtoneChannel');
      }
    } else if (volumeChannel == Channel.Notification) {
      if (ringtoneChannel == Channel.Ringtone) {
        await methodChannel
            .invokeMethod<String>('playRingtone_NotificationChannel');
      } else if (ringtoneChannel == Channel.Notification) {
        await methodChannel
            .invokeMethod<String>('playNotification_NotificationChannel');
      } else {
        await methodChannel
            .invokeMethod<String>('playAlarm_NotificationChannel');
      }
    } else {
      if (ringtoneChannel == Channel.Ringtone) {
        await methodChannel.invokeMethod<String>('playRingtone_AlarmChannel');
      } else if (ringtoneChannel == Channel.Notification) {
        await methodChannel
            .invokeMethod<String>('playNotification_AlarmChannel');
      } else {
        await methodChannel.invokeMethod<String>('playAlarm_AlarmChannel');
      }
    }
  }

  @override
  Future<void> stopSound() async {
    await methodChannel.invokeMethod<String>('stopSound');
  }
}
