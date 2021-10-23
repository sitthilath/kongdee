// To parse this JSON data, do
//
//     final buddhistFavorite = buddhistFavoriteFromJson(jsonString);

import 'dart:convert';

BuddhistFavorite buddhistFavoriteFromJson(String str) => BuddhistFavorite.fromJson(json.decode(str));

String buddhistFavoriteToJson(BuddhistFavorite data) => json.encode(data.toJson());

class BuddhistFavorite {
  BuddhistFavorite({
    this.data,
    this.meta,
  });

  List<FavoriteInfo> data;
  Meta meta;

  factory BuddhistFavorite.fromJson(Map<String, dynamic> json) => BuddhistFavorite(
    data: List<FavoriteInfo>.from(json["data"].map((x) => FavoriteInfo.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}

class FavoriteInfo {
  FavoriteInfo({
    this.id,
    this.buddhistId,
    this.userId,
    this.name,
    this.place,
    this.timeRemain,
    this.picture,
  });

  int id;
  int buddhistId;
  int userId;
  String name;
  String place;
  int timeRemain;
  List<String> picture;

  factory FavoriteInfo.fromJson(Map<String, dynamic> json) => FavoriteInfo(
    id: json["id"],
    buddhistId: json["buddhist_id"],
    userId: json["user_id"],
    name: json["name"],
    place: json["place"],
    timeRemain: json["time_remain"],
    picture: List<String>.from(json["picture"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "buddhist_id": buddhistId,
    "user_id": userId,
    "name": name,
    "place": place,
    "time_remain": timeRemain,
    "picture": List<dynamic>.from(picture.map((x) => x)),
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