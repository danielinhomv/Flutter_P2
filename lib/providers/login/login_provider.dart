import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../api/environment.dart';
import '../../models/response_api.dart';

class LoginProvider {
  final String _url = Environment.API_URL;
  final String _api = "/api/auth/login";

  BuildContext? context;

  Future? init(BuildContext context) {
    this.context = context;
    return null;
  }

  Future<ResponseApi?> login(String username, String password) async {
    try {
      Uri url = Uri.http(_url, _api);
      String bodyParams = json.encode({
        'username': username,
        'password': password,
      });
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final response = await post(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      // ignore: avoid_print
      print("Error: $error");
      return ResponseApi(error: 'Error de conexión');
    }
  }
}
