import 'dart:async';
import 'dart:collection';
import 'package:flutter/services.dart';
import 'package:notification_launcher/notification_message.dart';

import 'notification_response.dart';

export 'notification_action.dart';
export 'notification_launcher.dart';
export 'notification_message.dart';

typedef RemoteResponseListener = void Function(RemoteResponse);

class NotificationLauncher {
  static const MethodChannel platform = const MethodChannel('notification_launcher');


  static void setMessageListener(RemoteResponseListener rmListener) {
    platform.setMethodCallHandler((MethodCall methodCall) async {
      try {
        LinkedHashMap<Object?, Object?> args = methodCall.arguments;
        rmListener(RemoteResponse.fromJson(args.cast()));
        print("asgffs");
      } catch (e) {
        print("Deu Ruim $e");
      } finally {
      }
    });
  }

  static Future<void> sendMessage(NotificationMessage notificationMessage) async {
    await platform.invokeMethod('launchNotification', notificationMessage.toJson());
  }
}
