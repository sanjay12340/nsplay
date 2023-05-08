// To parse this JSON data, do
//
//     final transactionHistoryWithCount = transactionHistoryWithCountFromJson(jsonString);

import 'dart:convert';

TransactionHistoryWithCount transactionHistoryWithCountFromJson(String str) =>
    TransactionHistoryWithCount.fromJson(json.decode(str));

String transactionHistoryWithCountToJson(TransactionHistoryWithCount data) =>
    json.encode(data.toJson());

class TransactionHistoryWithCount {
  TransactionHistoryWithCount({
    this.transactionHistoryModal,
    this.total,
  });

  final List<TransactionHistoryModal>? transactionHistoryModal;
  final String? total;

  factory TransactionHistoryWithCount.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryWithCount(
        transactionHistoryModal: json["transaction_history_modal"] == null
            ? []
            : List<TransactionHistoryModal>.from(
                json["transaction_history_modal"]!
                    .map((x) => TransactionHistoryModal.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_history_modal": transactionHistoryModal == null
            ? []
            : List<dynamic>.from(
                transactionHistoryModal!.map((x) => x.toJson())),
        "total": total,
      };
}

class TransactionHistoryModal {
  TransactionHistoryModal({
    this.cAmount,
    this.credit,
    this.debit,
    this.cd,
    this.amount,
    this.finalAmount,
    this.time,
    this.bidDate,
    this.transactionMode,
    this.transAddWithdraw,
    this.comment,
    this.openClose,
    this.gameTypeFull,
    this.gameName,
    this.bidGameNumber,
    this.gameMode,
  });

  final String? cAmount;
  final String? credit;
  final String? debit;
  final String? cd;
  final String? amount;
  final String? finalAmount;
  final String? time;
  final String? bidDate;
  final String? transactionMode;
  final String? transAddWithdraw;
  final String? comment;
  final String? openClose;
  final String? gameTypeFull;
  final String? gameName;
  final String? bidGameNumber;
  final String? gameMode;

  factory TransactionHistoryModal.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryModal(
        cAmount: json["c_amount"],
        credit: json["credit"],
        debit: json["debit"],
        cd: json["cd"],
        amount: json["amount"],
        finalAmount: json["final_amount"],
        time: json["time"],
        bidDate: json["bid_date"],
        transactionMode: json["transaction_mode"],
        transAddWithdraw: json["trans_add_withdraw"],
        comment: json["comment"],
        openClose: json["open_close"],
        gameTypeFull: json["game_type_full"],
        gameName: json["game_name"],
        bidGameNumber: json["bid_game_number"],
        gameMode: json["game_mode"],
      );

  Map<String, dynamic> toJson() => {
        "c_amount": cAmount,
        "credit": credit,
        "debit": debit,
        "cd": cd,
        "amount": amount,
        "final_amount": finalAmount,
        "time": time,
        "bid_date": bidDate,
        "transaction_mode": transactionMode,
        "trans_add_withdraw": transAddWithdraw,
        "comment": comment,
        "open_close": openClose,
        "game_type_full": gameTypeFull,
        "game_name": gameName,
        "bid_game_number": bidGameNumber,
        "game_mode": gameMode,
      };
}
