class AverageSubject {
  final String materia;
  final double promedioMateria;

  AverageSubject({
    required this.materia,
    required this.promedioMateria,
  });

  factory AverageSubject.fromJson(Map<String, dynamic> json) => AverageSubject(
        materia: json["materia"],
        promedioMateria: json["promedio_materia"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "materia": materia,
        "promedio_materia": promedioMateria,
      };
}
