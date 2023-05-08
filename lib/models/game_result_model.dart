// To parse this JSON data, do
//
//     final gameResultModel = gameResultModelFromJson(jsonString);

import 'dart:convert';

List<GameResultModel> gameResultModelFromJson(String str) =>
    List<GameResultModel>.from(
        json.decode(str).map((x) => GameResultModel.fromJson(x)));

String gameResultModelToJson(List<GameResultModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameResultModel {
  GameResultModel({
    this.id,
    this.gameName,
    this.openTime,
    this.closeTime,
    this.ot,
    this.ct,
    this.gameOnOff,
    this.days,
    this.price,
    this.result,
    this.openStatus,
    this.closeStatus,
  });

  final String? id;
  final String? gameName;
  final String? openTime;
  final String? closeTime;
  final String? ot;
  final String? ct;
  final String? gameOnOff;
  final String? days;
  final String? price;
  final String? result;
  final bool? openStatus;
  final bool? closeStatus;

  factory GameResultModel.fromJson(Map<String, dynamic> json) =>
      GameResultModel(
        id: json["id"],
        gameName: json["game_name"],
        openTime: json["open_time"],
        closeTime: json["close_time"],
        ot: json["ot"],
        ct: json["ct"],
        gameOnOff: json["game_on_off"],
        days: json["days"],
        price: json["price"],
        result: json["result"],
        openStatus: json["open_status"] == "1",
        closeStatus: json["close_status"] == "1",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "game_name": gameName,
        "open_time": openTime,
        "close_time": closeTime,
        "ot": ot,
        "ct": ct,
        "game_on_off": gameOnOff,
        "days": days,
        "price": price,
        "result": result,
        "open_status": openStatus,
        "close_status": closeStatus,
      };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
