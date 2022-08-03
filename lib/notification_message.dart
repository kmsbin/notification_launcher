import 'package:intl/intl.dart';

import 'notification_action.dart';

class NotificationMessage {
  final int id;
  final String title;
  final String body;
  final List<NotificationAction> actions;
  final DateTime? scheduledDate;
  NotificationMessage({
    required this.id, 
    required this.title, 
    required this.body,
    this.actions = const [],
    this.scheduledDate
  });

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': id,
      'title': title,
      'body': body,
      'actions': actions.map((action) => action.toJson()).toList(),
      if (scheduledDate != null) 'scheduled_date': dateFormat.format(scheduledDate!)
    };
  }
}
