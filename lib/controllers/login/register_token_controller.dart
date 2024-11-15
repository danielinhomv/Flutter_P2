import 'package:flutter/material.dart';

import '../../models/device_token.dart';
import '../../models/response_api.dart';
import '../../providers/login/register_token_provider.dart';

class RegisterTokenController {
  BuildContext? context;

  RegisterTokenProvider registerTokenProvider = RegisterTokenProvider();

  void registerToken(DeviceToken deviceToken) async {
    final userId = deviceToken.userId;
    final token = deviceToken.token;

    if (userId.isNaN || token.isEmpty) {
      return;
    }

    ResponseApi? responseApi =
        await registerTokenProvider.registerToken(userId, token);
    // ignore: avoid_print
    print('REPUESTA REGISTER TOKEN: ${responseApi?.toJson()}');

    if (responseApi != null && responseApi.success!) {
      // ignore: avoid_print
      print('RESPUESTA REGISTER TOKEN: ${responseApi.message}');
    } else {
      // ignore: avoid_print
      print('RESPUESTA REGISTER TOKEN: ${responseApi?.error}');
    }
  }
}
