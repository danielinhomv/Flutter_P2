import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api/environment.dart';
import '../../models/notification.dart';
import '../../utils/shared_pref.dart';

class NotificationsProvider {
  final String _url = Environment.API_URL;
  final String _api = '/api/comunicados';
  final String _apiRegisterVisit =
      '/api/registrar_visita'; // Ruta de la nueva API

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  // Método para obtener las notificaciones
  Future<List<NotificationModel>?> getNotifications(int id) async {
    try {
      final user = SharedPref().read('user');
      final token = (await user)['token'];

      Uri url = Uri.http(_url, '$_api/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body)['data'];

      // ignore: avoid_print
      print('DATA: $data');

      NotificationModel results = NotificationModel.fromJsonList(data);
      return results.toList;
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return null;
    }
  }

  // Nuevo método para registrar una visita
  Future<void> registrarVisita(int comunicadoId, int userId) async {
    try {
      final user = SharedPref().read('user');
      final token = (await user)['token'];

      Uri url = Uri.http(_url, _apiRegisterVisit);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Cuerpo de la solicitud con los parámetros necesarios
      Map<String, dynamic> body = {
        'comunicado_id': comunicadoId,
        'user_id': userId,
      };
      print("cuerpo de la solicitud:$body");
      // Hacer la solicitud POST
      final res =
          await http.post(url, headers: headers, body: json.encode(body));

      // Si el servidor responde con éxito
      if (res.statusCode == 200) {
        final data = json.decode(res.body)['result'];
        print("visita registrada:$data");
      } else {
        print("visita no registrada");
      }
    } catch (e) {
      // Capturar cualquier error en el proceso
      print('Error al registrar visita: $e');
    }
  }
}
