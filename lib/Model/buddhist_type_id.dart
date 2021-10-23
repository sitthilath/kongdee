// To parse this JSON data, do
//
//     final buddhistDetailType = buddhistDetailTypeFromJson(jsonString);

import 'dart:convert';

BuddhistDetailListType buddhistDetailTypeFromJson(String str) => BuddhistDetailListType.fromJson(json.decode(str));

String buddhistDetailTypeToJson(BuddhistDetailListType data) => json.encode(data.toJson());

class BuddhistDetailListType {
  BuddhistDetailListType({
    this.data,
    this.meta,
  });

  Meta meta;
  List<Datum> data;

  factory BuddhistDetailListType.fromJson(Map<String, dynamic> json) => BuddhistDetailListType(
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
    this.id,
    this.name,
    this.place,
    this.picture,
    this.timeRemain,
  });

  int id;
  String name;
  String place;
  List<dynamic> picture;
  dynamic timeRemain;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    place: json["place"],
    picture: List<dynamic>.from(json["picture"].map((x) => x)),
    timeRemain: json["time_remain"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "place": place,
    "picture": List<dynamic>.from(picture.map((x) => x)),
    "time_remain": timeRemain,
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