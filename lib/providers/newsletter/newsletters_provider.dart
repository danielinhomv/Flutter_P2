import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api/environment.dart';
import '../../models/newsletter/newsletters.dart';
import '../../utils/shared_pref.dart';

class NewslettersProvider {
  final String _url = Environment.API_URL;
  final String _api = '/api/promedio_materias';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<Newsletter?> getNewsletters(
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
      print('DATA Provider Newsletters: $data');

      Newsletter results = Newsletter.fromJson(data);
      // ignore: avoid_print
      print('RESULTS Provider Newsletters: ${results.toJson()}');
      return results;
    } catch (e) {
      // ignore: avoid_print
      print('Error Provider Newsletters: $e');
      return null;
    }
  }
 
}
