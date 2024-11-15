import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api/environment.dart';
import '../../models/count_notifications_students.dart';
import '../../utils/shared_pref.dart';

class HomeProvider {
  final String _url = Environment.API_URL;
  final String _api = '/api/comunicados_hijos';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<CountNotificationsStudents?> getCountNotificationsStudents(int id) async {
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
      print('DATA HOME PROVIDER: $data');

      CountNotificationsStudents results = CountNotificationsStudents.fromJson(data);
      return results;
    } catch (e) {
      // ignore: avoid_print
      print('ERROR HOME PROVIDER: $e');
      return null;
    }
  }
  
}
