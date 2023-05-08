// To parse this JSON data, do
//
//     final starlineBidHistoryModel = starlineBidHistoryModelFromJson(jsonString);

import 'dart:convert';

List<StarlineBidHistoryModel> starlineBidHistoryModelFromJson(String str) => List<StarlineBidHistoryModel>.from(json.decode(str).map((x) => StarlineBidHistoryModel.fromJson(x)));

String starlineBidHistoryModelToJson(List<StarlineBidHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StarlineBidHistoryModel {
    StarlineBidHistoryModel({
        this.gameId,
        this.userId,
        this.bidAmount,
        this.bidNumber,
        this.winLoose,
        this.winAmount,
        this.gameType,
        this.time,
        this.date,
        this.createdAt,
        this.gameTypeFull,
        this.usrname,
        this.name,
    });

    final String? gameId;
    final String? userId;
    final String? bidAmount;
    final String? bidNumber;
    final String? winLoose;
    final String? winAmount;
    final String? gameType;
    final String? time;
    final String? date;
    final String? createdAt;
    final String? gameTypeFull;
    final String? usrname;
    final String? name;

    factory StarlineBidHistoryModel.fromJson(Map<String, dynamic> json) => StarlineBidHistoryModel(
        gameId: json["game_id"],
        userId: json["user_id"],
        bidAmount: json["bid_amount"],
        bidNumber: json["bid_number"],
        winLoose: json["win_loose"]!,
        winAmount: json["win_amount"],
        gameType: json["game_type"]!,
        time: json["time"],
        date: json["date"] ,
        createdAt: json["created_at"],
        gameTypeFull: json["game_type_full"]!,
        usrname: json["usrname"]!,
        name: json["name"]!,
    );

    Map<String, dynamic> toJson() => {
        "game_id": gameId,
        "user_id": userId,
        "bid_amount": bidAmount,
        "bid_number": bidNumber,
        "win_loose": winLoose,
        "win_amount": winAmount,
        "game_type": gameType,
        "time": time,
        "date": date,
        "created_at": createdAt,
        "game_type_full": gameTypeFull,
        "usrname":usrname,
        "name": name,
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
