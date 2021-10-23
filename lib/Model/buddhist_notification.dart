// To parse this JSON data, do
//
//     final buddhistNotification = buddhistNotificationFromJson(jsonString);

import 'dart:convert';

BuddhistNotification buddhistNotificationFromJson(String str) => BuddhistNotification.fromJson(json.decode(str));

String buddhistNotificationToJson(BuddhistNotification data) => json.encode(data.toJson());

class BuddhistNotification {
  BuddhistNotification({
    this.data,
    this.meta,
  });
  Meta meta;
  List<Datum> data;

  factory BuddhistNotification.fromJson(Map<String, dynamic> json) => BuddhistNotification(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}

class Datum {
  Datum({
    this.buddhistId,
    this.image,
    this.buddhistName,

    this.data,
    this.time,
    this.read,
    this.notificationType,
    this.commentPath,
    this.type,
    this.senderName,
    this.senderId
  });

  int buddhistId;
  List<String> image;
  String buddhistName;

  dynamic data;
  String time;
  int read;
  String notificationType;
  String commentPath;
  int type;
  String senderName;
  dynamic senderId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    buddhistId: json["buddhist_id"],
    image: List<String>.from(json["image"].map((x) => x)),
    buddhistName: json["buddhist_name"],

    data: json["data"],
    time: json["time"],
    read: json["read"],
    notificationType: json["notification_type"],
    commentPath: json["comment_path"],
    type: json["type"],
    senderName: json["sender_name"],
    senderId: json["sender_id"]
  );

  Map<String, dynamic> toJson() => {
    "buddhist_id": buddhistId,
    "image": List<dynamic>.from(image.map((x) => x)),
    "buddhist_name": buddhistName,

    "data":data,
    "time": time,
    "read": read,
    "notification_type" : notificationType,
    "comment_path" : commentPath,
    "type": type,
    "sender_name":senderName,
    "sender_id":senderId,
  };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],

    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,

    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}