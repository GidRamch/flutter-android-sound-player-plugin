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
  ) async {
    if (volumeChannel == Channel.alarm) {
      await methodChannel.invokeMethod<String>('playCustomSound_Alarm', {
        'uriString': uriString,
      });
    } else if (volumeChannel == Channel.notification) {
      await methodChannel.invokeMethod<String>('playCustomSound_Notification', {
        'uriString': uriString,
      });
    } else if (volumeChannel == Channel.media) {
      await methodChannel.invokeMethod<String>('playCustomSound_Media', {
        'uriString': uriString,
      });
    }
  }

  @override
  Future<void> playSound(
    Channel ringtoneChannel,
    Channel volumeChannel,
  ) async {
    if (volumeChannel == Channel.ringtone) {
      if (ringtoneChannel == Channel.ringtone) {
        await methodChannel
            .invokeMethod<String>('playRingtone_RingtoneChannel');
      } else if (ringtoneChannel == Channel.notification) {
        await methodChannel
            .invokeMethod<String>('playNotification_RingtoneChannel');
      } else if (ringtoneChannel == Channel.alarm) {
        await methodChannel.invokeMethod<String>('playAlarm_RingtoneChannel');
      }
    } else if (volumeChannel == Channel.notification) {
      if (ringtoneChannel == Channel.ringtone) {
        await methodChannel
            .invokeMethod<String>('playRingtone_NotificationChannel');
      } else if (ringtoneChannel == Channel.notification) {
        await methodChannel
            .invokeMethod<String>('playNotification_NotificationChannel');
      } else if (ringtoneChannel == Channel.alarm) {
        await methodChannel
            .invokeMethod<String>('playAlarm_NotificationChannel');
      }
    } else if (volumeChannel == Channel.alarm) {
      if (ringtoneChannel == Channel.ringtone) {
        await methodChannel.invokeMethod<String>('playRingtone_AlarmChannel');
      } else if (ringtoneChannel == Channel.notification) {
        await methodChannel
            .invokeMethod<String>('playNotification_AlarmChannel');
      } else if (ringtoneChannel == Channel.alarm) {
        await methodChannel.invokeMethod<String>('playAlarm_AlarmChannel');
      }
    } else if (volumeChannel == Channel.media) {
      if (ringtoneChannel == Channel.ringtone) {
        await methodChannel.invokeMethod<String>('playRingtone_MediaChannel');
      } else if (ringtoneChannel == Channel.notification) {
        await methodChannel
            .invokeMethod<String>('playNotification_MediaChannel');
      } else if (ringtoneChannel == Channel.alarm) {
        await methodChannel.invokeMethod<String>('playAlarm_MediaChannel');
      }
    }
  }

  @override
  Future<void> stopSound() async {
    await methodChannel.invokeMethod<String>('stopSound');
  }
}
