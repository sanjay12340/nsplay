// To parse this JSON data, do
//
//     final rules = rulesFromJson(jsonString);

import 'dart:convert';

List<Rules> rulesFromJson(String str) => List<Rules>.from(json.decode(str).map((x) => Rules.fromJson(x)));

String rulesToJson(List<Rules> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rules {
    Rules({
        this.text,
    });

    String? text;

    factory Rules.fromJson(Map<String, dynamic> json) => Rules(
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
    };
}
