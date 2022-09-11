package com.GidSchwifty.sound_player

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import android.media.AudioAttributes
import android.media.MediaPlayer
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine


/** SoundPlayerPlugin */
class SoundPlayerPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var mediaPlayer: MediaPlayer? = null;
    private var applicationContext: android.content.Context? = null;


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sound_player")

        applicationContext = flutterPluginBinding.applicationContext

        channel.setMethodCallHandler(this)
    }

    private fun stopSound(result: Result) {
        try {
            mediaPlayer?.stop();
            mediaPlayer = null;
        } catch (e: Error) {
            result.error("1", e.message, "Error in stopAlarm method")
        }
    }

    private fun playSound(uri: Uri, usage: Int, result: Result) {
        try {

            if (mediaPlayer != null) {
                try {
                    mediaPlayer?.stop();
                } catch (e: Error) {
                    // pass
                } finally {
                    mediaPlayer = null;
                }
            }

            mediaPlayer = MediaPlayer()

            mediaPlayer?.apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .setUsage(usage)
                        .build()
                )

                applicationContext?.let { setDataSource(it, uri) }
                prepare()
                start()
            }

            result.success(null)

        } catch (e: Error) {
            result.error("1", e.message, "Error in playAlarm method")
        }
    }


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "stopSound") {
            stopSound(result);
        } else if (call.method == "playAlarm_AlarmChannel") {
            playSound(
                Settings.System.DEFAULT_ALARM_ALERT_URI,
                AudioAttributes.USAGE_ALARM,
                result
            );
        } else if (call.method == "playNotification_AlarmChannel") {
            playSound(
                Settings.System.DEFAULT_NOTIFICATION_URI,
                AudioAttributes.USAGE_ALARM,
                result
            );
        } else if (call.method == "playRingtone_AlarmChannel") {
            playSound(
                Settings.System.DEFAULT_RINGTONE_URI,
                AudioAttributes.USAGE_ALARM,
                result
            );
        } else if (call.method == "playAlarm_RingtoneChannel") {
            playSound(
                Settings.System.DEFAULT_ALARM_ALERT_URI,
                AudioAttributes.USAGE_NOTIFICATION_RINGTONE,
                result
            );
        } else if (call.method == "playNotification_RingtoneChannel") {
            playSound(
                Settings.System.DEFAULT_NOTIFICATION_URI,
                AudioAttributes.USAGE_NOTIFICATION_RINGTONE,
                result
            );
        } else if (call.method == "playRingtone_RingtoneChannel") {
            playSound(
                Settings.System.DEFAULT_RINGTONE_URI,
                AudioAttributes.USAGE_NOTIFICATION_RINGTONE,
                result
            );
        } else if (call.method == "playAlarm_NotificationChannel") {
            playSound(
                Settings.System.DEFAULT_ALARM_ALERT_URI,
                AudioAttributes.USAGE_NOTIFICATION,
                result
            );
        } else if (call.method == "playNotification_NotificationChannel") {
            playSound(
                Settings.System.DEFAULT_NOTIFICATION_URI,
                AudioAttributes.USAGE_NOTIFICATION,
                result
            );
        } else if (call.method == "playRingtone_NotificationChannel") {
            playSound(
                Settings.System.DEFAULT_RINGTONE_URI,
                AudioAttributes.USAGE_NOTIFICATION,
                result
            );
        } else if (call.method == "stopAlarm") {
            try {
                mediaPlayer?.stop();
                mediaPlayer = null;
            } catch (e: Error) {
                result.error("1", e.message, "Error in stopAlarm method")
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
