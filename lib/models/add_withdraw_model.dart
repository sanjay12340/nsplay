// To parse this JSON data, do
//
//     final addWithDrawModel = addWithDrawModelFromJson(jsonString);

import 'dart:convert';

List<AddWithDrawModel> addWithDrawModelFromJson(String str) =>
    List<AddWithDrawModel>.from(
        json.decode(str).map((x) => AddWithDrawModel.fromJson(x)));

String addWithDrawModelToJson(List<AddWithDrawModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddWithDrawModel {
  AddWithDrawModel({
    this.wrId,
    this.wUserId,
    this.rMoney,
    this.rType,
    this.rType2,
    this.paymentType,
    this.paymentLink,
    this.status,
    this.createdAt,
    this.updateAt,
  });

  String? wrId;
  String? wUserId;
  String? rMoney;
  String? rType;
  String? rType2;
  String? paymentType;
  String? paymentLink;
  String? status;
  String? createdAt;
  String? updateAt;

  factory AddWithDrawModel.fromJson(Map<String, dynamic> json) =>
      AddWithDrawModel(
        wrId: json["wr_id"],
        wUserId: json["w_user_id"],
        rMoney: json["r_money"],
        rType: json["r_type"],
        rType2: json["r_type2"],
        paymentType: json["payment_type"],
        paymentLink: json["payment_link"],
        status: json["status"],
        createdAt: json["created_at"],
        updateAt: json["update_at"],
      );

  Map<String, dynamic> toJson() => {
        "wr_id": wrId,
        "w_user_id": wUserId,
        "r_money": rMoney,
        "r_type": rType,
        "r_type2": rType2,
        "payment_type": paymentType,
        "payment_link": paymentLink,
        "status": status,
        "created_at": createdAt,
        "update_at": updateAt,
      };
}
