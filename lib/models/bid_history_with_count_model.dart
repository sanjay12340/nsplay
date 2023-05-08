// To parse this JSON data, do
//
//     final bidHistoryWithCountModel = bidHistoryWithCountModelFromJson(jsonString);

import 'dart:convert';

BidHistoryWithCountModel bidHistoryWithCountModelFromJson(String str) => BidHistoryWithCountModel.fromJson(json.decode(str));

String bidHistoryWithCountModelToJson(BidHistoryWithCountModel data) => json.encode(data.toJson());

class BidHistoryWithCountModel {
    BidHistoryWithCountModel({
        this.results,
        this.count,
    });

    final List<BidHistoryModel>? results;
    final String? count;

    factory BidHistoryWithCountModel.fromJson(Map<String, dynamic> json) => BidHistoryWithCountModel(
        results: json["results"] == null ? [] : List<BidHistoryModel>.from(json["results"]!.map((x) => BidHistoryModel.fromJson(x))),
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "count": count,
    };
}

class BidHistoryModel {
    BidHistoryModel({
        this.bidId,
        this.bidAmount,
        this.gameId,
        this.status,
        this.bidGameNumber,
        this.full,
        this.openClose,
        this.gameType,
        this.winAmount,
        this.date,
        this.gameTypeFull,
        this.usrname,
        this.gameName,
        this.createeAt,
    });

    final String? bidId;
    final String? bidAmount;
    final String? gameId;
    final String? status;
    final String? bidGameNumber;
    final String? full;
    final String? openClose;
    final String? gameType;
    final String? winAmount;
    final String? date;
    final String? gameTypeFull;
    final String? usrname;
    final String? gameName;
    final String? createeAt;

    factory BidHistoryModel.fromJson(Map<String, dynamic> json) => BidHistoryModel(
        bidId: json["bid_id"],
        bidAmount: json["bid_amount"],
        gameId: json["game_id"],
        status: json["status"],
        bidGameNumber: json["bid_game_number"],
        full: json["full"],
        openClose: json["open_close"],
        gameType: json["game_type"],
        winAmount: json["win_amount"],
        date: json["date"] ,
        gameTypeFull: json["game_type_full"],
        usrname: json["usrname"],
        gameName: json["game_name"],
        createeAt: json["createe_at"],
    );

    Map<String, dynamic> toJson() => {
        "bid_id": bidId,
        "bid_amount": bidAmount,
        "game_id": gameId,
        "status": status,
        "bid_game_number": bidGameNumber,
        "full": full,
        "open_close": openClose,
        "game_type": gameType,
        "win_amount": winAmount,
        "date": date,
        "game_type_full": gameTypeFull,
        "usrname": usrname,
        "game_name": gameName,
        "createe_at": createeAt,
    };
}


