package com.kmsbin.notification_launcher

data class NotificationMessage(
    val title: String,
    val body: String,
    val id: Int,
    val actions: List<NotificationAction>

) {
    companion object {
        fun fromJson(jsonMap: HashMap<String, Object>) : NotificationMessage{
            val id: Int = (jsonMap["id"] as Int)
            val title: String = jsonMap["title"] as String
            val body = jsonMap["body"] as String
            val actions: List<NotificationAction> = (jsonMap["actions"] as List<HashMap<String, Any?>>).map{
                NotificationAction.fromJson(it)
            }
            return NotificationMessage(title, body, id, actions)
        }
    }
}


data class NotificationAction (
    var actionMsg: String,
    var actionValue: String
) {
    companion object {
        fun fromJson(jsonMap: HashMap<String, Any?>): NotificationAction {
            val actionMsg = jsonMap["action_msg"] as String
            val actionValue = jsonMap["action_value"] as String
            return NotificationAction(actionMsg, actionValue)
        }
    }
}

