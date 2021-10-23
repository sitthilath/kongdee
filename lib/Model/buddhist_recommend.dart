// To parse this JSON data, do
//
//     final buddhistBottomSearch = buddhistBottomSearchFromJson(jsonString);

import 'dart:convert';

BuddhistRecommend buddhistBottomSearchFromJson(String str) => BuddhistRecommend.fromJson(json.decode(str));

String buddhistBottomSearchToJson(BuddhistRecommend data) => json.encode(data.toJson());

class BuddhistRecommend {
  BuddhistRecommend({
    this.data,

  });


  List<Datum> data;

  factory BuddhistRecommend.fromJson(Map<String, dynamic> json) => BuddhistRecommend(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),

  };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.price,
    this.highestPrice,
    this.place,
    this.timeRemain,
    this.type,
    this.image,
  });

  int id;
  String name;
  dynamic price;
  dynamic highestPrice;
  String place;
  dynamic timeRemain;
  Type type;
  List<String> image;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    highestPrice: json["highest_price"],
    place: json["place"],
    timeRemain: json["time_remain"],
    type: Type.fromJson(json["type"]),
    image: List<String>.from(json["image"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "highest_price": highestPrice,
    "place": place,
    "time_remain": timeRemain,
    "type": type.toJson(),
    "image": List<dynamic>.from(image.map((x) => x)),
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

