// To parse this JSON data, do
//
//     final transactionModal = transactionModalFromJson(jsonString);

import 'dart:convert';

List<TransactionModal> transactionModalFromJson(String str) =>
    List<TransactionModal>.from(
        json.decode(str).map((x) => TransactionModal.fromJson(x)));

String transactionModalToJson(List<TransactionModal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionModal {
  TransactionModal({
    this.cAmount,
    this.credit,
    this.debit,
    this.finalAmount,
    this.time,
    this.transactionMode,
    this.transAddWidthdraw,
    this.comment,
    this.openClose,
    this.gameTypeFull,
    this.gameName,
    this.cd,
    this.amount,
    this.bidGameNumber,
    this.bidDate,
    this.gameMode,
  });

  final String? cAmount;
  final String? credit;
  final String? debit;
  final String? finalAmount;
  final String? time;
  final String? transactionMode;
  final String? transAddWidthdraw;
  final String? comment;
  final String? openClose;
  final String? gameTypeFull;
  final String? gameName;
  final String? cd;
  final String? amount;
  final String? bidGameNumber;
  final String? bidDate;
  final String? gameMode;

  factory TransactionModal.fromJson(Map<String, dynamic> json) =>
      TransactionModal(
        cAmount: json["c_amount"],
        credit: json["credit"],
        debit: json["debit"],
        finalAmount: json["final_amount"],
        time: json["time"],
        transactionMode: json["transaction_mode"],
        transAddWidthdraw: json["trans_add_widthdraw"],
        comment: json["comment"],
        openClose: json["open_close"],
        gameTypeFull: json["game_type_full"],
        gameName: json["game_name"],
        cd: json["cd"],
        amount: json["amount"],
        bidGameNumber: json["bid_game_number"],
        bidDate: json["bid_date"],
        gameMode: json["game_mode"],
      );

  Map<String, dynamic> toJson() => {
        "c_amount": cAmount,
        "credit": credit,
        "debit": debit,
        "final_amount": finalAmount,
        "time": time,
        "transaction_mode": transactionMode,
        "trans_add_widthdraw": transAddWidthdraw,
        "comment": comment,
        "open_close": openClose,
        "game_type_full": gameTypeFull,
        "cd": cd,
        "amount": amount,
        "bid_game_number": bidGameNumber,
        "bid_date": bidDate,
        "game_mode": gameMode,
      };
}
