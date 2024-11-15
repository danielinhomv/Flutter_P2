import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../api/environment.dart';
import '../../models/response_api.dart';
import '../../utils/shared_pref.dart';

class RegisterTokenProvider {
  final String _url = Environment.API_URL;
  final String _api = "/api/registrar_token";

  BuildContext? context;

  Future? init(BuildContext context) {
    this.context = context;
    return null;
  }

  Future<ResponseApi?> registerToken(int userId, String tokenDevice) async {
    try {
      final user = await SharedPref().read('user');
      final token = (await user)['token'];
      
      Uri url = Uri.http(_url, _api);
      String bodyParams = json.encode({
        'user_id': userId,
        'token': tokenDevice,
      });
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await post(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      // ignore: avoid_print
      print("Error: $error");
      return ResponseApi(message: 'Error de conexión');
    }
  }
}
