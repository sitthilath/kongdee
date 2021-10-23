// To parse this JSON data, do
//
//     final notificationCount = notificationCountFromJson(jsonString);

import 'dart:convert';

NotificationCount notificationCountFromJson(String str) => NotificationCount.fromJson(json.decode(str));

String notificationCountToJson(NotificationCount data) => json.encode(data.toJson());

class NotificationCount {
  NotificationCount({
    this.notificationCount,
  });

  int notificationCount;

  factory NotificationCount.fromJson(Map<String, dynamic> json) => NotificationCount(
    notificationCount: json["notification_count"],
  );

  Map<String, dynamic> toJson() => {
    "notification_count": notificationCount,
  };
}
