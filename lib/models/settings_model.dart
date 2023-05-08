// To parse this JSON data, do
//
//     final settingsModel = settingsModelFromJson(jsonString);

import 'dart:convert';

List<SettingsModel> settingsModelFromJson(String str) => List<SettingsModel>.from(json.decode(str).map((x) => SettingsModel.fromJson(x)));

String settingsModelToJson(List<SettingsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SettingsModel {
    SettingsModel({
        this.id,
        this.type,
        this.name,
        this.value,
    });

    String? id;
    String? type;
    String? name;
    String? value;

    factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        id: json["id"],
        type: json["type"],
        name: json["name"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "value": value,
    };
}
