// To parse this JSON data, do
//
//     final betNumber = betNumberFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<BetNumberModal> betNumberFromJson(String str) => List<BetNumberModal>.from(
    json.decode(str).map((x) => BetNumberModal.fromJson(x)));

String betNumberToJson(List<BetNumberModal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BetNumberModal {
  BetNumberModal({
    @required this.gameid,
    @required this.price,
    @required this.userid,
    this.status = "pending",
    @required this.number,
    @required this.openclose,
    @required this.gametype,
    @required this.date,
    @required this.gametypefull,
  });

  int? gameid;
  int? price;
  int? userid;
  String? status;
  String? number;
  String? openclose;
  String? gametype;
  String? date;
  String? gametypefull;

  factory BetNumberModal.fromJson(Map<String, dynamic> json) => BetNumberModal(
        gameid: json["gameid"],
        price: json["price"],
        userid: json["userid"],
        status: json["status"],
        number: json["number"],
        openclose: json["openclose"],
        gametype: json["gametype"],
        date: json['date'],
        gametypefull: json['gametypefull'],
      );

  Map<String, dynamic> toJson() => {
        "gameid": gameid,
        "price": price,
        "userid": userid,
        "status": status,
        "number": number,
        "openclose": openclose,
        "gametype": gametype,
        "date": date,
        "gametypefull": gametypefull,
      };
}
