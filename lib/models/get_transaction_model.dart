// To parse this JSON data, do
//
//     final getTransation = getTransationFromJson(jsonString);

import 'dart:convert';

List<GetTransation> getTransationFromJson(String str) =>
    List<GetTransation>.from(
        json.decode(str).map((x) => GetTransation.fromJson(x)));

String getTransationToJson(List<GetTransation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTransation {
  GetTransation({
    this.id,
    this.userId,
    this.cAmount,
    this.credit,
    this.debit,
    this.finalAmount,
    this.date,
    this.createdAt,
    this.comment,
    this.uids,
  });

  String? id;
  String? userId;
  String? cAmount;
  String? credit;
  String? debit;
  String? finalAmount;
  String? date;
  String? createdAt;
  String? comment;
  String? uids;

  factory GetTransation.fromJson(Map<String, dynamic> json) => GetTransation(
        id: json["id"],
        userId: json["userId"],
        cAmount: json["cAmount"],
        credit: json["credit"],
        debit: json["debit"],
        finalAmount: json["finalAmount"],
        date: json["date"],
        createdAt: json["createdAt"],
        comment: json["comment"],
        uids: json["uids"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "cAmount": cAmount,
        "credit": credit,
        "debit": debit,
        "finalAmount": finalAmount,
        "date": date,
        "createdAt": createdAt,
        "comment": comment,
        "uids": uids,
      };
}
