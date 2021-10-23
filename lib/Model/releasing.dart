// To parse this JSON data, do
//
//     final failRelease = failReleaseFromJson(jsonString);

import 'dart:convert';

Releasing failReleaseFromJson(String str) => Releasing.fromJson(json.decode(str));

String failReleaseToJson(Releasing data) => json.encode(data.toJson());

class Releasing {
  Releasing({
    this.data,
    this.meta,
  });
  Meta meta;
  List<ReleasingData> data;

  factory Releasing.fromJson(Map<String, dynamic> json) => Releasing(
    data: List<ReleasingData>.from(json["data"].map((x) => ReleasingData.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}

class ReleasingData {
  ReleasingData({
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
  int timeRemain;
  Type type;
  List<String> image;

  factory ReleasingData.fromJson(Map<String, dynamic> json) => ReleasingData(
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
