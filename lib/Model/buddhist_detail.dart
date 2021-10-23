// To parse this JSON data, do
//
//     final buddhistDetail = buddhistDetailFromJson(jsonString);

import 'dart:convert';

BuddhistDetail buddhistDetailFromJson(String str) => BuddhistDetail.fromJson(json.decode(str));

String buddhistDetailToJson(BuddhistDetail data) => json.encode(data.toJson());

class BuddhistDetail {
  BuddhistDetail({
    this.data,
  });

  List<BuddhistDetailData> data;

  factory BuddhistDetail.fromJson(Map<String, dynamic> json) => BuddhistDetail(
    data: List<BuddhistDetailData>.from(json["data"].map((x) => BuddhistDetailData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BuddhistDetailData {
  BuddhistDetailData({
    this.id,
    this.name,
    this.detail,
    this.price,
    this.highestPrice,
    this.startTime,
    this.endTime,
    this.timeRemain,
    this.type,
    this.user,
    this.ownerId,
    this.favorite,
    this.image,

    this.place,
    this.status,
    this.highBidUser,
    this.favoriteCount,
    this.priceSmallest,
  });

  int id;
  String name;
  String detail;
  dynamic price;
  dynamic highestPrice;
  String startTime;
  DateTime endTime;
  int timeRemain;
  Type type;
  String user;
  int ownerId;
  int favorite;
  List<String> image;

  String place;
  String status;
  int highBidUser;
  int favoriteCount;
  int priceSmallest;

  factory BuddhistDetailData.fromJson(Map<String, dynamic> json) => BuddhistDetailData(
    id: json["id"],
    name: json["name"],
    detail: json["detail"],
    price: json["price"],
    highestPrice: json["highest_price"],
    startTime: json["start_time"],
    endTime: DateTime.parse(json["end_time"]),
    timeRemain: json["time_remain"],
    type: Type.fromJson(json["type"]),
    user: json["user"],
    ownerId: json["owner_id"],
    favorite: json["favorite"],
    image: List<String>.from(json["image"].map((x) => x)),

    place: json["place"],
    status: json["status"],
    highBidUser: json["highBidUser"],
    favoriteCount: json["favoriteCount"],
    priceSmallest: json["priceSmallest"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "detail": detail,
    "price": price,
    "highest_price": highestPrice,
    "start_time": startTime,
    "end_time": endTime.toIso8601String(),
    "time_remain": timeRemain,
    "type": type.toJson(),
    "user": user,
    "owner_id": ownerId,
    "favorite": favorite,
    "image": List<dynamic>.from(image.map((x) => x)),

    "place": place,
    "status": status,
    "highBidUser": highBidUser,
    "favoriteCount": favoriteCount,
    "priceSmallest": priceSmallest,
  };
}

class Type {
  Type({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
