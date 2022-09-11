import 'package:flutter_test/flutter_test.dart';
import 'package:sound_player/sound_player.dart';
import 'package:sound_player/sound_player_platform_interface.dart';
import 'package:sound_player/sound_player_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSoundPlayerPlatform
    with MockPlatformInterfaceMixin
    implements SoundPlayerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SoundPlayerPlatform initialPlatform = SoundPlayerPlatform.instance;

  test('$MethodChannelSoundPlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSoundPlayer>());
  });

  test('getPlatformVersion', () async {
    SoundPlayer soundPlayerPlugin = SoundPlayer();
    MockSoundPlayerPlatform fakePlatform = MockSoundPlayerPlatform();
    SoundPlayerPlatform.instance = fakePlatform;

    expect(await soundPlayerPlugin.getPlatformVersion(), '42');
  });
}
