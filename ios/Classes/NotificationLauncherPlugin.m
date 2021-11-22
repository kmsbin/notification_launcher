#import "NotificationLauncherPlugin.h"
#if __has_include(<notification_launcher/notification_launcher-Swift.h>)
#import <notification_launcher/notification_launcher-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notification_launcher-Swift.h"
#endif

@implementation NotificationLauncherPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificationLauncherPlugin registerWithRegistrar:registrar];
}
@end
