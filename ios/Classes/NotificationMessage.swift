//
//  NotificationMessage.swift
//  notification_launcher
//
//  Created by kauli miranda sabino on 12/07/22.
//

import Foundation

struct NotificationMessage {
    var title: String
    var body: String
    var id: Int
    var actions: [NotificationAction]
    var scheduledDate: Date?
    
    static func fromJson(map: [String : Any]) -> NotificationMessage {
        var scheduledDate: Date? = nil
        let rawScheduledDate = map["scheduled_date"] as? String
        NSLog("rawScheduledDate \(rawScheduledDate)")
        if rawScheduledDate != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            // necessary to avoid daylight saving (and other time shift) problems
            dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
            // necessary to avoid problems with 12h vs 24h time formatting
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")

            scheduledDate = dateFormatter.date(from: rawScheduledDate!)
        }
        NSLog("scheduledDate \(scheduledDate)")
        
        return NotificationMessage(
            title: map["title"] as! String,
            body: map["body"] as! String,
            id: map["id"] as! Int,
            actions: (map["actions"] as! [[String: Any]]).map(NotificationAction.fromJson),
            scheduledDate: scheduledDate
        )
    }
}

struct NotificationAction {
    var actionMsg: String
    var actionValue: String
    
    static func fromJson(map: [String: Any]) -> NotificationAction {
        return NotificationAction(
            actionMsg: map["action_msg"] as! String,
            actionValue: map["action_value"] as! String
        )
    }
}

//
//data class NotificationAction (
//    var actionMsg: String,
//    var actionValue: String
//) {
//    companion object {
//        fun fromJson(jsonMap: HashMap<String, Any?>): NotificationAction {
//            val actionMsg = jsonMap["action_msg"] as String
//            val actionValue = jsonMap["action_value"] as String
//            return NotificationAction(actionMsg, actionValue)
//        }
//    }
//}
