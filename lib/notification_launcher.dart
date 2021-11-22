
import 'dart:async';

import 'package:flutter/services.dart';

class NotificationLauncher {
  static const MethodChannel platform = const MethodChannel('notification_launcher');

  static Future<String?> get platformVersion async {
    final String? version = await platform.invokeMethod('launchNotification');
    platform.setMethodCallHandler(nativeMethodCallHandler);
    return version;
  }

  static Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    print('Native call!');
    switch (methodCall.method) {
      case "yep" :
        print("MESSAGE FROM BROADCAST ${methodCall.method}");
        print("Arguments ${methodCall.arguments}");    
        return "This data from flutter.....";
      default:
        return "Nothing";
    }
  }
}
