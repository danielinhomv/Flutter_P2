import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api/environment.dart';
import '../../models/qualifications/qualifications.dart';
import '../../utils/shared_pref.dart';

class QualificationsProvider {
  final String _url = Environment.API_URL;
  final String _api = '/api/calificaciones_materia';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<Qualifications?> getQualificationsSubject(
      int alumnoId, int gestionId, int periodoId) async {
    try {
      final user = SharedPref().read('user');
      final token = (await user)['token'];

      Uri url = Uri.http(_url, '$_api/$alumnoId/$gestionId/$periodoId');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body)['data'];

      // ignore: avoid_print
      print('DATA Provider Qualifications: $data');

      Qualifications results = Qualifications.fromJson(data);
      // ignore: avoid_print
      print('RESULTS Provider Qualifications: ${results.toJson()}');
      return results;
    } catch (e) {
      // ignore: avoid_print
      print('Error Provider Qualifications: $e');
      return null;
    }
  }
 
}
