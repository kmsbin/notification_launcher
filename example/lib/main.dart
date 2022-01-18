import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notification_launcher/notification_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    NotificationLauncher.setMessageListener((rmMessage) {
      print("ID: ${rmMessage.id}");
      print("CHOISE: ${rmMessage.choise}");
    });
  }

  Future<void> sendMessage() async {
    try {
      NotificationLauncher.sendMessage(NotificationMessage(
        body: 'random body', 
        id: Random().nextInt(1000), 
        title: 'random title',
        actions: [
          NotificationAction(actionMsg: 'Sim', actionValue: 'y'),
          NotificationAction(actionMsg: 'Não', actionValue: 'n'),
          NotificationAction(actionMsg: 'mAY', actionValue: 'm'),
          NotificationAction(actionMsg: 'nunca', actionValue: 'k'),
          NotificationAction(actionMsg: 'sempre', actionValue: 's'),
        ]
      ));
    } on PlatformException {
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: sendMessage, 
            child: Text('Send notification')
          ),
        ),
      ),
    );
  }
}
