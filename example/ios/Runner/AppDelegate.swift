import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      NSLog("All set!")
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
          if success {
              NSLog("All set!")
          } else if let error = error {
              NSLog(error.localizedDescription)
          }
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      NSLog("hi!")
      result("iOS " + UIDevice.current.systemVersion);
        
    }
}
	
