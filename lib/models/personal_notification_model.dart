// To parse this JSON data, do
//
//     final personalNotifiactionModel = personalNotifiactionModelFromJson(jsonString);

import 'dart:convert';

List<PersonalNotifiactionModel> personalNotifiactionModelFromJson(String str) =>
    List<PersonalNotifiactionModel>.from(
        json.decode(str).map((x) => PersonalNotifiactionModel.fromJson(x)));

String personalNotifiactionModelToJson(List<PersonalNotifiactionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PersonalNotifiactionModel {
  PersonalNotifiactionModel({
    this.id,
    this.notice,
    this.date,
    this.noticeTo,
    this.title,
  });

  String? id;
  String? notice;
  DateTime? date;
  String? noticeTo;
  String? title;

  factory PersonalNotifiactionModel.fromJson(Map<String, dynamic> json) =>
      PersonalNotifiactionModel(
        id: json["id"],
        notice: json["notice"],
        date: DateTime.parse(json["date"]),
        noticeTo: json["notice_to"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notice": notice,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "notice_to": noticeTo,
        "title": title,
      };
}
