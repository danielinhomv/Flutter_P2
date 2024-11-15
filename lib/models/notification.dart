import 'dart:convert';

List<NotificationModel> notificationsFromMap(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationsToMap(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  late int id;
  late String titulo;
  late String mensaje;
  late String bytePdfJson;
  late String fecha;
  late String tipo;
  late String? remitente;
  late List<NotificationModel> toList = [];

  NotificationModel({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.bytePdfJson,
    required this.fecha,
    required this.tipo,
    required this.remitente,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        titulo: json["titulo"],
        mensaje: json["mensaje"],
        bytePdfJson: json["bytePdfJson"],
        fecha: json["fecha"],
        tipo: json["tipo"],
        remitente: json["remitente"] == "False False"
            ? "Administración Académica"
            : json["remitente"],
      );

  NotificationModel.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      NotificationModel notificationsRequest = NotificationModel.fromJson(item);
      toList.add(notificationsRequest);
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "titulo": titulo,
        "mensaje": mensaje,
        "bytePdfJson": bytePdfJson,
        "fecha": fecha,
        "tipo": tipo,
        "remitente": remitente,
      };
}
