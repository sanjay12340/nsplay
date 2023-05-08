// To parse this JSON data, do
//
//     final betNumber = betNumberFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<BetNumberStarlineModal> betNumberStarlineFromJson(String str) =>
    List<BetNumberStarlineModal>.from(
        json.decode(str).map((x) => BetNumberStarlineModal.fromJson(x)));

String betNumberStarlineToJson(List<BetNumberStarlineModal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BetNumberStarlineModal {
  BetNumberStarlineModal( {
    @required this.gameid,
    @required this.price,
    @required this.userid,
    this.status = "pending",
    @required this.number,
    @required this.time,
    @required this.gametype,
    @required this.date,
    @required this.gametypefull,
    this.usrname, this.name,
  });

  int? gameid;
  int? price;
  int? userid;
  String? status;
  String? number;
  String? time;
  String? gametype;
  String? date;
  String? gametypefull;
   final String? usrname;
  final  String? name;


  factory BetNumberStarlineModal.fromJson(Map<String, dynamic> json) =>
      BetNumberStarlineModal(
        gameid: json["gameid"],
        price: json["price"],
        userid: json["userid"],
        status: json["status"],
        number: json["number"],
        time: json["time"],
        gametype: json["gametype"],
        date: json['date'],
        gametypefull: json['gametypefull'],
        usrname: json['usrname'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        "gameid": gameid,
        "price": price,
        "userid": userid,
        "status": status,
        "number": number,
        "time": time,
        "gametype": gametype,
        "date": date,
        "gametypefull": gametypefull,
        "usrname": usrname,
        "name": name,
      };
}
