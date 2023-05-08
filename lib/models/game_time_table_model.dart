// To parse this JSON data, do
//
//     final gameTimeTableModel = gameTimeTableModelFromJson(jsonString);

import 'dart:convert';

List<GameTimeTableModel> gameTimeTableModelFromJson(String str) =>
    List<GameTimeTableModel>.from(
        json.decode(str).map((x) => GameTimeTableModel.fromJson(x)));

String gameTimeTableModelToJson(List<GameTimeTableModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameTimeTableModel {
  GameTimeTableModel({
    this.id,
    this.gameName,
    this.openTime,
    this.closeTime,
    this.gameOnOff,
    this.days,
    this.price,
  });

  String? id;
  String? gameName;
  String? openTime;
  String? closeTime;
  String? gameOnOff;
  String? days;
  String? price;

  factory GameTimeTableModel.fromJson(Map<String, dynamic> json) =>
      GameTimeTableModel(
        id: json["id"],
        gameName: json["game_name"],
        openTime: json["open_time"],
        closeTime: json["close_time"],
        gameOnOff: json["game_on_off"],
        days: json["days"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "game_name": gameName,
        "open_time": openTime,
        "close_time": closeTime,
        "game_on_off": gameOnOff,
        "days": days,
        "price": price,
      };
}
