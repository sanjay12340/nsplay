// To parse this JSON data, do
//
//     final getInviteDetail = getInviteDetailFromJson(jsonString);

import 'dart:convert';

GetInviteDetail getInviteDetailFromJson(String str) =>
    GetInviteDetail.fromJson(json.decode(str));

String getInviteDetailToJson(GetInviteDetail data) =>
    json.encode(data.toJson());

class GetInviteDetail {
  GetInviteDetail({
    this.todayContribution,
    this.todayActiveUSer,
    this.totalInvitedUser,
    this.bonus,
  });

  String? todayContribution;
  String? todayActiveUSer;
  String? totalInvitedUser;
  String? bonus;

  factory GetInviteDetail.fromJson(Map<String, dynamic> json) =>
      GetInviteDetail(
        todayContribution: json["todayContribution"],
        todayActiveUSer: json["todayActiveUSer"],
        totalInvitedUser: json["totalInvitedUser"],
        bonus: json["bonus"],
      );

  Map<String, dynamic> toJson() => {
        "todayContribution": todayContribution,
        "todayActiveUSer": todayActiveUSer,
        "totalInvitedUser": totalInvitedUser,
        "bonus": bonus,
      };
}
