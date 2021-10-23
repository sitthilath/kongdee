// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.data,
  });

  UserInfo data;

  factory User.fromJson(Map<String, dynamic> json) => User(
    data: UserInfo.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class UserInfo {
  UserInfo({
    this.id,
    this.name,
    this.surname,
    this.phoneNumber,
    this.picture,

  });

  int id;
  String name;
  String surname;
  String phoneNumber;
  String picture;


  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"],
    name: json["name"],
    surname: json["surname"],
    phoneNumber: json["phone_number"],
    picture: json["picture"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "surname": surname,
    "phone_number": phoneNumber,
    "picture": picture,

  };
}
