import 'dart:convert';

List<Management> managementFromMap(String str) =>
    List<Management>.from(json.decode(str).map((x) => Management.fromJson(x)));

String managementToMap(List<Management> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Management {
  late int id;
  late String year;
  late List<Management> toList = [];

  Management({
    required this.id,
    required this.year,
  });

  factory Management.fromJson(Map<String, dynamic> json) => Management(
        id: json["id"],
        year: json["year"],
      );
  
  Management.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      Management managementsRequest = Management.fromJson(item);
      toList.add(managementsRequest);
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "year": year,
      };
}
