// To parse this JSON data, do
//
//     final gameLastTwoResultModel = gameLastTwoResultModelFromJson(jsonString);

import 'dart:convert';

List<GameLastTwoResultModel> gameLastTwoResultModelFromJson(String str) =>
    List<GameLastTwoResultModel>.from(
        json.decode(str).map((x) => GameLastTwoResultModel.fromJson(x)));

String gameLastTwoResultModelToJson(List<GameLastTwoResultModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameLastTwoResultModel {
  GameLastTwoResultModel({
    required this.gamename,
    required this.result,
  });

  final String gamename;
  final String result;

  factory GameLastTwoResultModel.fromJson(Map<String, dynamic> json) =>
      GameLastTwoResultModel(
        gamename: json["gamename"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "gamename": gamename,
        "result": result,
      };
}
