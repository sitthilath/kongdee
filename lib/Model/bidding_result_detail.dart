
import 'dart:convert';

BiddingResultDetail biddingResultDetailFromJson(String str) => BiddingResultDetail.fromJson(json.decode(str));

String biddingResultDetailToJson(BiddingResultDetail data) => json.encode(data.toJson());

class BiddingResultDetail {
  BiddingResultDetail({
    this.data,
  });

  BiddingResultDetailData data;

  factory BiddingResultDetail.fromJson(Map<String, dynamic> json) => BiddingResultDetail(
    data: BiddingResultDetailData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class BiddingResultDetailData {
  BiddingResultDetailData({
    this.text,
    this.winnerId,
    this.winnerImage,
    this.winnerName,
    this.winnerSurname,
    this.winnerPhone,
    this.winnerPrice,
    this.ownerName,
    this.ownerSurname,
    this.ownerPhone,
    this.buddhistImage,
    this.ownerImage,
    this.ownerId,
    this.buddhistId,
  });

  String text;
  int winnerId;
  String winnerImage;
  String winnerName;
  String winnerSurname;
  String winnerPhone;
  dynamic winnerPrice;
  String ownerName;
  String ownerSurname;
  String ownerPhone;
  List<String> buddhistImage;
  String ownerImage;
  int ownerId;
  int buddhistId;


  factory BiddingResultDetailData.fromJson(Map<String, dynamic> json) => BiddingResultDetailData(
    text: json["text"],
    winnerId:json["winnerId"],
    winnerImage: json["winnerImage"],
    winnerName: json["winner_name"],
    winnerSurname: json["winner_surname"],
    winnerPhone: json["winnerPhone"],
    winnerPrice: json["winner_price"],
    ownerName: json["owner_name"],
    ownerSurname: json["owner_surname"],
    ownerPhone: json["owner_phone"],
    buddhistImage: List<String>.from(json["buddhist_image"].map((x) => x)),
    ownerImage: json["owner_image"],
    ownerId: json["owner_id"],
    buddhistId: json["buddhist_id"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "winnerId":winnerId,
    "winnerImage":winnerImage,
    "winner_name": winnerName,
    "winner_surname": winnerSurname,
    "winnerPhone":winnerPhone,
    "winner_price": winnerPrice,
    "owner_name": ownerName,
    "owner_surname": ownerSurname,
    "owner_phone": ownerPhone,
    "buddhist_image": List<dynamic>.from(buddhistImage.map((x) => x)),
    "owner_image": ownerImage,
    "owner_id":ownerId,
    "buddhist_id":buddhistId,
  };
}
