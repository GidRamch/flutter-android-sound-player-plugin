import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sound_player/models/channel_type.dart';
import 'package:sound_player/sound_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _soundPlayerPlugin = SoundPlayer();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _soundPlayerPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app $_platformVersion'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const TimerClockFace(),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _soundPlayerPlugin.playSound(
                          Channel.alarm,
                          Channel.alarm,
                        );
                      },
                      child: const Text('C: Alarm, R: Alarm'),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _soundPlayerPlugin.playSound(
                          Channel.ringtone,
                          Channel.alarm,
                        );
                      },
                      child: const Text('C: Alarm, R: Ringtone'),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _soundPlayerPlugin.playSound(
                          Channel.notification,
                          Channel.alarm,
                        );
                      },
                      child: const Text('C: Alarm, R: Notification'),
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _soundPlayerPlugin.playSound(
                          Channel.alarm,
                          Channel.ringtone,
                        );
                      },
                      child: const Text('C: Ringtone, R: Alarm'),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _soundPlayerPlugin.playSound(
                          Channel.ringtone,
                          Channel.ringtone,
                        );
                      },
                      child: const Text('C: Ringtone, R: Ringtone'),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _soundPlayerPlugin.playSound(
                            Channel.notification, Channel.ringtone);
                      },
                      child: const Text('C: Ringtone, R: Notification'),
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _soundPlayerPlugin.playSound(
                            Channel.alarm, Channel.notification);
                      },
                      child: const Text('C: Notification, R: Alarm'),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _soundPlayerPlugin.playSound(
                            Channel.ringtone, Channel.notification);
                      },
                      child: const Text('C: Notification, R: Ringtone'),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _soundPlayerPlugin.playSound(
                            Channel.notification, Channel.notification);
                      },
                      child: const Text('C: Notification, R: Notification'),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _soundPlayerPlugin.playCustomSound(
                          'assets/ringtones/beep-2.mp3',
                          Channel.alarm,
                        );
                      },
                      child: const Text('Custom Sound Alarm'),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _soundPlayerPlugin.stopSound();
                      },
                      child: const Text('Stop'),
                    ),
                  ],
                ),
                // const TimerSessionInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
