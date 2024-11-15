
import 'detail_subject.dart';

class Subject {
  late String materia;
  late double promedioMateria;
  late List<DetailSubject> details;

  Subject({
    required this.materia,
    required this.promedioMateria,
    required this.details,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        materia: json["materia"],
        promedioMateria: (json['promedio_materia'] ?? 0).toDouble(),
        details:
            List<DetailSubject>.from(json["details"].map((x) => DetailSubject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "materia": materia,
        "promedio_materia": promedioMateria,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}



