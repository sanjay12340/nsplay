// To parse this JSON data, do
//
//     final betNumber = betNumberFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<BetNumberHalfFullModal> betNumberFromJson(String str) =>
    List<BetNumberHalfFullModal>.from(
        json.decode(str).map((x) => BetNumberHalfFullModal.fromJson(x)));

String betNumberToJson(List<BetNumberHalfFullModal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BetNumberHalfFullModal {
  BetNumberHalfFullModal({
    @required this.gameid,
    @required this.bidamount,
    @required this.userid,
    this.status = "pending",
    @required this.openclose,
    @required this.gametype,
    @required this.date,
    @required this.fn,
    @required this.fno,
    @required this.snc,
    @required this.sn,
    @required this.gametypefull,
  });

  final int? gameid;
  final int? bidamount;
  final int? userid;
  final String? status;
  final String? fn;
  final String? fno;
  final String? snc;
  final String? sn;
  final String? gametype;
  final String? date;
  final String? openclose;
  String? gametypefull;

  factory BetNumberHalfFullModal.fromJson(Map<String, dynamic> json) =>
      BetNumberHalfFullModal(
        gameid: json["gameid"],
        bidamount: json["bidamount"],
        userid: json["userid"],
        status: json["status"],
        fn: json["fn"],
        fno: json["fno"],
        snc: json["snc"],
        sn: json["sn"],
        openclose: json["openclose"],
        gametype: json["gametype"],
        date: json['date'],
        gametypefull: json['gametypefull'],
      );

  Map<String, dynamic> toJson() => {
        "gameid": gameid,
        "bidamount": bidamount,
        "userid": userid,
        "status": status,
        "fn": fn,
        "fno": fno,
        "snc": snc,
        "sn": sn,
        "openclose": openclose,
        "gametype": gametype,
        "date": date,
        "gametypefull": gametypefull,
      };
}
