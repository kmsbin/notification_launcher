import Flutter
import UIKit
import UserNotifications

public class SwiftNotificationLauncherPlugin: NSObject, FlutterPlugin, UNUserNotificationCenterDelegate {
    static var channel: FlutterMethodChannel?
    static let categoryName = "action_messager_notification"
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "notification_launcher", binaryMessenger: registrar.messenger())
        let instance = SwiftNotificationLauncherPlugin()
          //1
        
        let center = UNUserNotificationCenter.current()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (accepted, error) in configureCategory(center)
        }
        registrar.addMethodCallDelegate(instance, channel: channel!)

    }

    private static func configureCategory(_ center: UNUserNotificationCenter) {
        NSLog("cu")
        
        let confirmationAction = UNNotificationAction(identifier: "confirm", title: "yes", options: [])
        let denyAtion = UNNotificationAction(identifier: "deny", title: "no", options: [])
        
        let tutorialCategory = UNNotificationCategory(
            identifier: SwiftNotificationLauncherPlugin.categoryName,
            actions: [confirmationAction, denyAtion],
            intentIdentifiers: [], options: []
        )
        
        center.setNotificationCategories([tutorialCategory])
    }
    
    public func handle(_ call: FlutterMethodCall, result: FlutterResult) {
        if (call.method == "launchNotification") {
            launchNotification(notificationMessage: NotificationMessage.fromJson(map: call.arguments as! [String: Any]))
        } else {
            result("")
        }
    }
    
    private func launchNotification(notificationMessage: NotificationMessage) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {(accepted, error) in
            if accepted {
                let center = UNUserNotificationCenter.current()
                center.delegate = self
                        
                let content = UNMutableNotificationContent()
                content.title = notificationMessage.title
                content.body = notificationMessage.body
                content.categoryIdentifier = UUID().uuidString
                let actions = notificationMessage.actions.map({(action) in
                    return UNNotificationAction(identifier: action.actionValue, title: action.actionMsg, options: [])
                })
                
                let tutorialCategory = UNNotificationCategory(
                    identifier: content.categoryIdentifier,
                    actions: actions,
                    intentIdentifiers: [], options: []
                )
                
                center.setNotificationCategories([tutorialCategory])
                
                var trigger: UNNotificationTrigger!
                
                if notificationMessage.scheduledDate != nil {
                    let calendar = Calendar.current
                    let comp = calendar.dateComponents(
                        [.year, .month, .day, .hour, .minute, .second],
                        from: notificationMessage.scheduledDate!
                    )
                    trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
                    NSLog("scheduled date \(comp)")
                } else {
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                }
                
                let request = UNNotificationRequest(identifier: String(notificationMessage.id), content: content, trigger: trigger)

                center.add(request)

            } else {
                NSLog("not accepted")
            }
        }
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {

        completionHandler(.alert)
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        NSLog("GO IN HERE 2")
        var methodChannelResponse = [String : Any]()
        methodChannelResponse["id"] = Int(response.notification.request.identifier)
        methodChannelResponse["choise"] = response.actionIdentifier
        SwiftNotificationLauncherPlugin.channel?.invokeMethod("message_reply", arguments: methodChannelResponse)
        NSLog("\(response.actionIdentifier)")
    }
}
