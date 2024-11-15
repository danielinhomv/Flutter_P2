import 'dart:convert';

import 'subject.dart';

Qualifications qualificationsFromMap(String str) =>
    Qualifications.fromJson(json.decode(str));

String qualificationsToMap(Qualifications data) => json.encode(data.toJson());

class Qualifications {
  late double promedioGeneral;
  late List<Subject> materias;

  Qualifications({
    required this.promedioGeneral,
    required this.materias,
  });

  factory Qualifications.fromJson(Map<String, dynamic> json) => Qualifications(
        promedioGeneral: (json['promedio_general'] ?? 0).toDouble(),
        materias: List<Subject>.from(
            json["materias"].map((x) => Subject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promedio_general": promedioGeneral,
        "materias": List<dynamic>.from(materias.map((x) => x.toJson())),
      };
}
