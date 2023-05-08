// To parse this JSON data, do
//
//     final gameRateModel = gameRateModelFromJson(jsonString);

import 'dart:convert';

List<GameRateModel> gameRateModelFromJson(String str) =>
    List<GameRateModel>.from(
        json.decode(str).map((x) => GameRateModel.fromJson(x)));

String gameRateModelToJson(List<GameRateModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameRateModel {
  GameRateModel({
    this.fname,
    this.price,
  });

  String? fname;
  String? price;

  factory GameRateModel.fromJson(Map<String, dynamic> json) => GameRateModel(
        fname: json["fname"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "fname": fname,
        "price": price,
      };
}
