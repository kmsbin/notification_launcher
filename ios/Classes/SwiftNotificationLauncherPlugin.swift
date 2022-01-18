import Flutter
import UIKit
import UserNotifications

public class SwiftNotificationLauncherPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "notification_launcher", binaryMessenger: registrar.messenger())
    let instance = SwiftNotificationLauncherPlugin()
    NSLog("HAANDDLLLLEEE")
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
    }
      //1


    registrar.addMethodCallDelegate(instance, channel: channel)

  }

  public func handle(_ call: FlutterMethodCall, result: FlutterResult) {
    NSLog("HAANDDLLLLEEE")
    
    let uuidString = "gasdf gs drfgsertgh s"
      	
    let content = UNMutableNotificationContent()
    content.title =  "Hello!"
    content.body = "Hello_message_body"
      
    let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest.init(identifier: uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { (error) in
      print("Deu ruim irmão \(error)")
      if error != nil {
        
      }
    }
    
    NSLog("HAANDDLLLLEEE")
    result("")
  }
  func getNotificationSettings() {
         
  
  }

}
