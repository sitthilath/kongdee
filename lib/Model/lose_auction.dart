// To parse this JSON data, do
//
//     final loseAuction = loseAuctionFromJson(jsonString);

import 'dart:convert';

LoseAuction loseAuctionFromJson(String str) => LoseAuction.fromJson(json.decode(str));

String loseAuctionToJson(LoseAuction data) => json.encode(data.toJson());

class LoseAuction {
  LoseAuction({
    this.data,
    this.meta,
  });

  List<LoseAuctionData> data;
  Meta meta;

  factory LoseAuction.fromJson(Map<String, dynamic> json) => LoseAuction(
    data: List<LoseAuctionData>.from(json["data"].map((x) => LoseAuctionData.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}

class LoseAuctionData {
  LoseAuctionData({
    this.id,
    this.name,
    this.highestPrice,
    this.timeRemain,
    this.place,
    this.image,
  });

  int id;
  String name;
  dynamic highestPrice;
  int timeRemain;
  String place;
  List<String> image;

  factory LoseAuctionData.fromJson(Map<String, dynamic> json) => LoseAuctionData(
    id: json["id"],
    name: json["name"],
    highestPrice: json["highest_price"],
    timeRemain: json["time_remain"],
    place: json["place"],
    image: List<String>.from(json["image"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "highest_price": highestPrice,
    "time_remain": timeRemain,
    "place":place,
    "image": List<dynamic>.from(image.map((x) => x)),
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