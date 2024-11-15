// To parse this JSON data, do
//
//     final newsletter = newsletterFromMap(jsonString);

import 'dart:convert';

import 'average_subject.dart';

Newsletter newsletterFromMap(String str) =>
    Newsletter.fromJson(json.decode(str));

String newsletterToMap(Newsletter data) => json.encode(data.toJson());

class Newsletter {
  final String alumno;
  final String gestion;
  final String periodo;
  final String curso;
  final double promedioGeneral;
  final List<AverageSubject> materiasPromedio;

  Newsletter({
    required this.alumno,
    required this.gestion,
    required this.periodo,
    required this.curso,
    required this.promedioGeneral,
    required this.materiasPromedio,
  });

  factory Newsletter.fromJson(Map<String, dynamic> json) => Newsletter(
        alumno: json["alumno"],
        gestion: json["gestion"],
        periodo: json["periodo"],
        curso: json["curso"],
        promedioGeneral: json["promedio_general"]?.toDouble(),
        materiasPromedio: List<AverageSubject>.from(
            json["materias_promedio"].map((x) => AverageSubject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "alumno": alumno,
        "gestion": gestion,
        "periodo": periodo,
        "curso": curso,
        "promedio_general": promedioGeneral,
        "materias_promedio":
            List<dynamic>.from(materiasPromedio.map((x) => x.toJson())),
      };
}
