package com.GidSchwifty.sound_player

import android.content.res.AssetFileDescriptor
import android.content.res.AssetManager
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.net.Uri
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** SoundPlayerPlugin */
class SoundPlayerPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var mediaPlayer: MediaPlayer? = null;
    private var binding: FlutterPluginBinding? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sound_player")
        channel.setMethodCallHandler(this)
        binding = flutterPluginBinding
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

                binding?.applicationContext?.let { setDataSource(it, uri) }
                prepare()
                start()
            }

            result.success(null)

        } catch (e: Error) {
            result.error("1", e.message, "Error in playAlarm method")
        }
    }


    private fun playCustomSound(
        uriString: String,
        packageName: String,
        usage: Int,
        result: Result
    ) {
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

            val assetPath: String =
                binding?.flutterAssets?.getAssetFilePathBySubpath(uriString, packageName)
                    ?: return

            val afd: AssetFileDescriptor =
                binding?.applicationContext?.assets?.openFd(assetPath) ?: return


            mediaPlayer = MediaPlayer()



            mediaPlayer?.apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .setUsage(usage)
                        .build()
                )
//                setDataSource(uriString)
                setDataSource(afd.fileDescriptor, afd.startOffset, afd.length);
//                binding?.applicationContext?.let { setDataSource(it, Uri.parse(assetPath)) }
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
        } else if (call.method == "playCustomSound_Alarm") {
            playCustomSound(
                call?.argument<String>("uriString") ?: "",
                call?.argument<String>("packageName") ?: "",
                AudioAttributes.USAGE_ALARM,
                result
            );
        } else if (call.method == "playCustomSound_Notification") {
            call.argument<String>("uriString")?.let {
                call.argument<String>("packageName")?.let {
                    playCustomSound(
                        it,
                        it,
                        AudioAttributes.USAGE_NOTIFICATION,
                        result
                    )
                }
            };
        } else if (call.method == "playCustomSound_Media") {
            call.argument<String>("uriString")?.let {
                call.argument<String>("packageName")?.let {
                    playCustomSound(
                        it,
                        it,
                        AudioAttributes.USAGE_MEDIA,
                        result
                    )
                }
            };
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
        this.binding = null
    }
}
