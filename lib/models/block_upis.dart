// To parse this JSON data, do
//
//     final blockUpis = blockUpisFromJson(jsonString);

import 'dart:convert';

List<BlockUpis> blockUpisFromJson(String str) =>
    List<BlockUpis>.from(json.decode(str).map((x) => BlockUpis.fromJson(x)));

String blockUpisToJson(List<BlockUpis> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlockUpis {
  BlockUpis({
    this.id,
    this.upi,
  });

  String? id;
  String? upi;

  factory BlockUpis.fromJson(Map<String, dynamic> json) => BlockUpis(
        id: json["id"],
        upi: json["upi"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "upi": upi,
      };
}
