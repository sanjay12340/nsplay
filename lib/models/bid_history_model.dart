// To parse this JSON data, do
//
//     final bidHistoryModel = bidHistoryModelFromJson(jsonString);

import 'dart:convert';

List<BidHistoryModel> bidHistoryModelFromJson(String str) =>
    List<BidHistoryModel>.from(
        json.decode(str).map((x) => BidHistoryModel.fromJson(x)));

String bidHistoryModelToJson(List<BidHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BidHistoryModel {
  BidHistoryModel(
      {this.bidId,
      this.bidAmount,
      this.gameId,
      this.status,
      this.bidGameNumber,
      this.full,
      this.openClose,
      this.gameType,
      this.winAmount,
      this.date,
      this.usrname,
      this.gameName,
      this.gameTypeFull,
      this.createeAt});

  String? bidId;
  String? bidAmount;
  String? gameId;
  String? status;
  String? bidGameNumber;
  String? full;
  String? openClose;
  String? gameType;
  String? winAmount;
  String? date;
  String? usrname;
  String? gameName;
  String? createeAt;
  String? gameTypeFull;

  factory BidHistoryModel.fromJson(Map<String, dynamic> json) =>
      BidHistoryModel(
        bidId: json["bid_id"],
        bidAmount: json["bid_amount"],
        gameId: json["game_id"],
        status: json["status"],
        bidGameNumber: json["bid_game_number"],
        full: json["full"],
        openClose: json["open_close"],
        gameType: json["game_type"],
        winAmount: json["win_amount"],
        date: json["date"],
        usrname: json["usrname"],
        gameName: json["game_name"],
        createeAt: json["createe_at"],
        gameTypeFull: json["game_type_full"],
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
        "usrname": usrname,
        "game_name": gameName,
        "createe_at": createeAt,
        "game_type_full": gameTypeFull,
      };
}
