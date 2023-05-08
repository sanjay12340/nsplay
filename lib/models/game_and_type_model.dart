// To parse this JSON data, do
//
//     final gameAndType = gameAndTypeFromJson(jsonString);

import 'dart:convert';

GameAndType gameAndTypeFromJson(String str) =>
    GameAndType.fromJson(json.decode(str));

String gameAndTypeToJson(GameAndType data) => json.encode(data.toJson());

class GameAndType {
  GameAndType({
    this.gameTypeModel,
    this.game,
  });

  List<GameTypeModel>? gameTypeModel;
  List<Game>? game;

  factory GameAndType.fromJson(Map<String, dynamic> json) => GameAndType(
        gameTypeModel: List<GameTypeModel>.from(
            json["GameTypeModel"].map((x) => GameTypeModel.fromJson(x))),
        game: List<Game>.from(json["Game"].map((x) => Game.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "GameTypeModel":
            List<dynamic>.from(gameTypeModel!.map((x) => x.toJson())),
        "Game": List<dynamic>.from(game!.map((x) => x.toJson())),
      };
}

class Game {
  Game({
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
  GameOnOff? gameOnOff;
  Days? days;
  String? price;

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json["id"],
        gameName: json["game_name"],
        openTime: json["open_time"],
        closeTime: json["close_time"],
        gameOnOff: gameOnOffValues.map![json["game_on_off"]],
        days: daysValues.map![json["days"]],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "game_name": gameName,
        "open_time": openTime,
        "close_time": closeTime,
        "game_on_off": gameOnOffValues.reverse![gameOnOff],
        "days": daysValues.reverse![days],
        "price": price,
      };
}

enum Days { THE_123456, THE_1234560, THE_12345 }

final daysValues = EnumValues({
  "1-2-3-4-5-": Days.THE_12345,
  "1-2-3-4-5-6-": Days.THE_123456,
  "1-2-3-4-5-6-0-": Days.THE_1234560
});

enum GameOnOff { YES }

final gameOnOffValues = EnumValues({"yes": GameOnOff.YES});

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
