class LastResult {
  LastResult({
    this.name,
    this.result,
    this.time,
  });

  String? name;
  String? result;
  String? time;

  factory LastResult.fromJson(Map<String, dynamic> json) => LastResult(
        name: json["name"],
        result: json["result"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "result": result,
        "time": time,
      };
}
