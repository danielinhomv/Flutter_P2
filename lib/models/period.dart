import 'dart:convert';

List<Period> periodFromMap(String str) =>
    List<Period>.from(json.decode(str).map((x) => Period.fromJson(x)));

String periodToMap(List<Period> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Period {
  late int id;
  late String descripcion;
  late List<Period> toList = [];

  Period({
    required this.id,
    required this.descripcion,
  });

  factory Period.fromJson(Map<String, dynamic> json) => Period(
        id: json["id"],
        descripcion: json["descripcion"],
      );
      
  Period.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      Period periodsRequest = Period.fromJson(item);
      toList.add(periodsRequest);
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
      };
}
