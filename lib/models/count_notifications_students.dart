import 'dart:convert';

CountNotificationsStudents countNotificationsFromMap(String str) => CountNotificationsStudents.fromJson(json.decode(str));

String countNotificationsToMap(CountNotificationsStudents data) => json.encode(data.toJson());

class CountNotificationsStudents {
    final int comunicados;
    final int hijos;

    CountNotificationsStudents({
        required this.comunicados,
        required this.hijos,
    });

    factory CountNotificationsStudents.fromJson(Map<String, dynamic> json) => CountNotificationsStudents(
        comunicados: json["comunicados"],
        hijos: json["hijos"],
    );

    Map<String, dynamic> toJson() => {
        "comunicados": comunicados,
        "hijos": hijos,
    };
}
