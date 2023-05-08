// To parse this JSON data, do
//
//     final gameTypeModel = gameTypeModelFromJson(jsonString);

import 'dart:convert';

List<GameTypeModel> gameTypeModelFromJson(String str) =>
    List<GameTypeModel>.from(
        json.decode(str).map((x) => GameTypeModel.fromJson(x)));

String gameTypeModelToJson(List<GameTypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameTypeModel {
  GameTypeModel({
    this.id,
    this.name,
    this.fname,
  });

  String? id;
  String? name;
  String? fname;

  factory GameTypeModel.fromJson(Map<String, dynamic> json) => GameTypeModel(
        id: json["id"],
        name: json["name"],
        fname: json["fname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "fname": fname,
      };
}
