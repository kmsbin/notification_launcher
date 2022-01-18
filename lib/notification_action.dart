class NotificationAction {
  final String actionMsg;
  final String actionValue;

  NotificationAction({
    required this.actionMsg, 
    required this.actionValue
  });
  
  Map<String, dynamic> toJson() {
    return {
      'action_msg': actionMsg,
      'action_value': actionValue,
    };
  }
}