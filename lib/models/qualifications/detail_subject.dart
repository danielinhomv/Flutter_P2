class DetailSubject {
  late int id;
  late String curso;
  late double nota;
  late String gestion;
  late String periodo;
  late String descripcion;
  late String profesor;

  DetailSubject({
    required this.id,
    required this.curso,
    required this.nota,
    required this.gestion,
    required this.periodo,
    required this.descripcion,
    required this.profesor,
  });

  factory DetailSubject.fromJson(Map<String, dynamic> json) => DetailSubject(
        id: json["id"],
        curso: json["curso"],
        nota: json["nota"].toDouble(),
        gestion: json["gestion"],
        periodo: json["periodo"],
        descripcion: json["descripcion"],
        profesor: json["profesor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "curso": curso,
        "nota": nota,
        "gestion": gestion,
        "periodo": periodo,
        "descripcion": descripcion,
        "profesor": profesor,
      };
}