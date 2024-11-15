import 'dart:convert';

List<Qualification> qualificationFromMap(String str) =>
    List<Qualification>.from(
        json.decode(str).map((x) => Qualification.fromJson(x)));

String qualificationToMap(List<Qualification> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Qualification {
  late int id;
  late String materia;
  late String curso;
  late double nota;
  late String gestion;
  late String periodo;
  late String descripcion;
  late List<Qualification> toList = [];

  Qualification({
    required this.id,
    required this.materia,
    required this.curso,
    required this.nota,
    required this.gestion,
    required this.periodo,
    required this.descripcion,
  });

  factory Qualification.fromJson(Map<String, dynamic> json) => Qualification(
        id: json["id"],
        materia: json["materia"],
        curso: json["curso"],
        nota: json["nota"],
        gestion: json["gestion"],
        periodo: json["periodo"],
        descripcion: json["descripcion"],
      );
      
  Qualification.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      Qualification qualificationsRequest = Qualification.fromJson(item);
      toList.add(qualificationsRequest);
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "materia": materia,
        "curso": curso,
        "nota": nota,
        "gestion": gestion,
        "periodo": periodo,
        "descripcion": descripcion,
      };
}
