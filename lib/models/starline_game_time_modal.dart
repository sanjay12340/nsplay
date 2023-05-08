// To parse this JSON data, do
//
//     final starlineGameTime = starlineGameTimeFromJson(jsonString);

import 'dart:convert';

List<StarlineGameTime> starlineGameTimeFromJson(String str) =>
    List<StarlineGameTime>.from(
        json.decode(str).map((x) => StarlineGameTime.fromJson(x)));

String starlineGameTimeToJson(List<StarlineGameTime> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StarlineGameTime {
  StarlineGameTime({
    this.id,
    this.gameId,
    this.time,
    this.days,
    this.gameOnOff,
    this.showTime,
  });

  final String? id;
  final String? gameId;
  final String? time;
  final String? days;
  final String? gameOnOff;
  final String? showTime;

  factory StarlineGameTime.fromJson(Map<String, dynamic> json) =>
      StarlineGameTime(
        id: json["id"],
        gameId: json["game_id"],
        time: json["time"],
        days: json["days"]!,
        showTime: json["show_time"],
        gameOnOff: json["game_on_off"]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "game_id": gameId,
        "time": time,
        "days": days,
        "show_time": showTime,
        "game_on_off": gameOnOff,
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
