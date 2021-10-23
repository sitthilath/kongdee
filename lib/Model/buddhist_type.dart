// To parse this JSON data, do
//
//     final buddhistType = buddhistTypeFromJson(jsonString);

import 'dart:convert';

BuddhistType buddhistTypeFromJson(String str) => BuddhistType.fromJson(json.decode(str));

String buddhistTypeToJson(BuddhistType data) => json.encode(data.toJson());

class BuddhistType {
  BuddhistType({
    this.data,
  });

  List<Datum> data;

  factory BuddhistType.fromJson(Map<String, dynamic> json) => BuddhistType(
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
    this.imagePath,
  });

  int id;
  String name;
  String imagePath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_path": imagePath,
  };
}
