import 'notification_action.dart';

class NotificationMessage {
  final int id;
  final String title;
  final String body;
  final List<NotificationAction> actions;

  NotificationMessage({
    required this.id, 
    required this.title, 
    required this.body,
    this.actions = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'actions': actions.map((action) => action.toJson()).toList()
    };
  }
}
