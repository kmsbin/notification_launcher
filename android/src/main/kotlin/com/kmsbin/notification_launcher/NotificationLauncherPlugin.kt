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
import kotlin.random.Random

class NotificationLauncherPlugin: FlutterPlugin, MethodCallHandler {
  private var notificationRequestCodeCount: Int = 1

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

        launchNotification(call)

      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  private fun launchNotification(call: MethodCall) {
    val smallIcon = context.resources.getIdentifier(
      "ic_launcher",
      "mipmap",
      context.packageName
    )
    val notificationMessage = NotificationMessage.fromJson(call.arguments as HashMap<String, Object>)
      // notificationMessage.id = 1
    with(NotificationManagerCompat.from(context)) {
        // notificationId is a unique int for each notification that you must define

        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val service: String = Context.NOTIFICATION_SERVICE

            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel("id", notificationMessage.title, importance).apply {
                description = notificationMessage.body
            }

            val notificationManager: NotificationManager = context.getSystemService(service) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }

        val builder = NotificationCompat.Builder(context, "id")
          .setSmallIcon(smallIcon)
          .setContentTitle(notificationMessage.title)
          .setContentText(notificationMessage.body)
          .setPriority(NotificationCompat.PRIORITY_HIGH)

        for ((index, action) in notificationMessage.actions.withIndex()) {
            val snoozeIntentNo = Intent(context, MyBroadcastReceiver::class.java).apply {
                putExtra("action_msg", action.actionValue)
                putExtra("id", notificationMessage.id)
            }

            val snoozePendingIntentNo: PendingIntent =
                PendingIntent.getBroadcast(context, ++notificationRequestCodeCount, snoozeIntentNo,  PendingIntent.FLAG_IMMUTABLE)

            builder.addAction(smallIcon, action.actionMsg, snoozePendingIntentNo)
        }

        notify(notificationMessage.id, builder.build())
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

class MyBroadcastReceiver : BroadcastReceiver() {
  override fun onReceive(context: Context, intent: Intent) {
    print("On receivee")

    val notiId = intent.getIntExtra("id", -1)
    if (notiId > 0) {
      
      val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager 
      
      notificationManager.cancel(notiId)
      val channel: MethodChannel = NotificationLauncherPlugin.channel
      
      val extra = intent.getStringExtra("action_msg")

      channel.invokeMethod("message_reply", mapOf(Pair("id", notiId),Pair("choise", extra)))
    }
  }
}




