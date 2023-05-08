// To parse this JSON data, do
//
//     final gameResultModelTotalStarline = gameResultModelTotalStarlineFromJson(jsonString);

import 'dart:convert';

GameResultModelTotalStarline gameResultModelTotalStarlineFromJson(String str) =>
    GameResultModelTotalStarline.fromJson(json.decode(str));

String gameResultModelTotalStarlineToJson(GameResultModelTotalStarline data) =>
    json.encode(data.toJson());

class GameResultModelTotalStarline {
  GameResultModelTotalStarline({
    required this.dateTime,
    required this.date,
    required this.time,
    required this.gameResultModelStarline,
    required this.lastResultStarline,
  });

  DateTime dateTime;
  DateTime date;
  String time;
  List<GameResultModelStarline> gameResultModelStarline;
  LastResultStarline lastResultStarline;

  factory GameResultModelTotalStarline.fromJson(Map<String, dynamic> json) =>
      GameResultModelTotalStarline(
        dateTime: DateTime.parse(json["date_time"]),
        date: DateTime.parse(json["date"]),
        time: json["time"],
        gameResultModelStarline: List<GameResultModelStarline>.from(
            json["GameResultModel_starline"]
                .map((x) => GameResultModelStarline.fromJson(x))),
        lastResultStarline:
            LastResultStarline.fromJson(json["lastResult_starline"]),
      );

  Map<String, dynamic> toJson() => {
        "date_time": dateTime.toIso8601String(),
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "GameResultModel_starline":
            List<dynamic>.from(gameResultModelStarline.map((x) => x.toJson())),
        "lastResult_starline": lastResultStarline.toJson(),
      };
}

class GameResultModelStarline {
  GameResultModelStarline({
    required this.id,
    required this.time,
    required this.days,
    required this.gameOnOff,
    required this.gameName,
    required this.ct,
    required this.resultTime,
    required this.closeTime,
    required this.nextday,
    required this.mor,
    required this.result,
    required this.result2,
  });

  String? id;
  String? time;
  String? days;
  String? gameOnOff;
  String? gameName;
  String? ct;
  String? resultTime;
  String? closeTime;
  String? nextday;
  String? mor;
  String? result;
  String? result2;

  factory GameResultModelStarline.fromJson(Map<String, dynamic> json) =>
      GameResultModelStarline(
        id: json["id"],
        time: json["time"],
        days: json["days"]!,
        gameOnOff: json["game_on_off"]!,
        gameName: json["game_name"]!,
        ct: json["ct"],
        resultTime: json["result_time"],
        closeTime: json["close_time"],
        nextday: json["nextday"],
        mor: json["mor"],
        result: json["result"]!,
        result2: json["result2"]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time,
        "days": days,
        "game_on_off": gameOnOff,
        "game_name": gameName,
        "ct": ct,
        "result_time": resultTime,
        "close_time": closeTime,
        "nextday": nextday,
        "mor": mor,
        "result": result,
        "result2": result,
      };
}

class LastResultStarline {
  LastResultStarline({
    required this.name,
    required this.result,
    required this.time,
  });

  final String? name;
  final String? result;
  final String? time;

  factory LastResultStarline.fromJson(Map<String, dynamic> json) =>
      LastResultStarline(
        name: json["name"]!,
        result: json["result"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "result": result,
        "time": time,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
