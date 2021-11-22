import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notification_launcher/notification_launcher.dart';

void main() {
  const MethodChannel channel = MethodChannel('notification_launcher');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('launchNotification', () async {
    expect(await NotificationLauncher.platformVersion, '42');
  });
}
