package com.kmsbin.notification_launcher

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Notification
import android.content.Context
import android.content.*
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import android.util.Log
import android.widget.Toast

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.Optional

/** NotificationLauncherPlugin */
class NotificationLauncherPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  companion object {
    public lateinit var channel : MethodChannel
  }

  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "notification_launcher")
    context = flutterPluginBinding.applicationContext
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "launchNotification") {
      launchNotification()
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  private fun launchNotification() {
    val smallIcon = context.resources.getIdentifier(
      "ic_launcher",
      "mipmap",
      context.packageName
    )

    with(NotificationManagerCompat.from(context)) {
        // notificationId is a unique int for each notification that you must define
        val someNotificationId = 1;

        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val service: String = Context.NOTIFICATION_SERVICE

            val name = "Some name"
            val descriptionText = "Desc"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel("id", name, importance).apply {
                description = descriptionText
            }

            val notificationManager: NotificationManager =
                    context.getSystemService(service) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
        
        val snoozeIntentYep = Intent(context, MyBroadcastReceiver::class.java).apply {
            putExtra("action_msg", "yep")  
            putExtra("id", someNotificationId)
        }
        val snoozePendingIntentYep: PendingIntent = 
          PendingIntent.getBroadcast(context, 2, snoozeIntentYep, 2)
      
        val snoozeIntentNo = Intent(context, MyBroadcastReceiver::class.java).apply {
          putExtra("action_msg", "nop")
          putExtra("id", someNotificationId)
        }
        val snoozePendingIntentNo: PendingIntent = 
          PendingIntent.getBroadcast(context, 2, snoozeIntentNo, 2)
    

        val builder = NotificationCompat.Builder(context, "id")
          .setSmallIcon(smallIcon)
          .setContentTitle("Title")
          .setContentText("Text")
          .setPriority(NotificationCompat.PRIORITY_DEFAULT)
          .addAction(smallIcon, "yep", snoozePendingIntentYep)
          .addAction(smallIcon, "not", snoozePendingIntentNo)
          

        notify(someNotificationId, builder.build())
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }  
}

class MyBroadcastReceiver : BroadcastReceiver() {
  private val TAG = "MyBroadcastReceiver"

  override fun onReceive(context: Context, intent: Intent) {
    print("On receivee")

    val noti_id = intent.getIntExtra("id", -1)
    if (noti_id > 0) {
      
      val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager 
      
      notificationManager.cancel(noti_id)
      val channel: MethodChannel = NotificationLauncherPlugin.channel
      
      val cs: CharSequence = noti_id.toString()
      val extra = intent.getStringExtra("action_msg")

      channel.invokeMethod("yep", mapOf(Pair("ID", noti_id),Pair("CHOISE", extra)))

      StringBuilder().apply {
        append("Action: ${intent.action} flag: ${extra}\n")
        append("URI: ${intent.toUri(Intent.URI_INTENT_SCHEME)}\n")
        toString().also { log ->
          Log.d(TAG, log)
          Toast.makeText(context, cs, Toast.LENGTH_LONG).show()
        }
      }
    }
  }
}




