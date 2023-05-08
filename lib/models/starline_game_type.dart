// To parse this JSON data, do
//
//     final starlineGameType = starlineGameTypeFromJson(jsonString);

import 'dart:convert';

List<StarlineGameType> starlineGameTypeFromJson(String str) =>
    List<StarlineGameType>.from(
        json.decode(str).map((x) => StarlineGameType.fromJson(x)));

String starlineGameTypeToJson(List<StarlineGameType> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StarlineGameType {
  StarlineGameType({
    this.id,
    this.typeName,
    this.typeName2,
    this.price,
  });

  final String? id;
  final String? typeName;
  final String? typeName2;
  final String? price;

  factory StarlineGameType.fromJson(Map<String, dynamic> json) =>
      StarlineGameType(
        id: json["id"],
        typeName: json["type_name"],
        typeName2: json["type_name2"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
        "type_name2": typeName2,
        "price": price,
      };
}
