import 'package:flutter/material.dart';

import '../../models/device_token.dart';
import '../../models/response_api.dart';
import '../../models/user.dart';
import '../../providers/login/login_provider.dart';
import '../../utils/my_snackbar.dart';
import '../../utils/shared_pref.dart';
import 'register_token_controller.dart';

RegisterTokenController registerTokenController = RegisterTokenController();

class LoginController {
  BuildContext? context;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginProvider loginProvider = LoginProvider();
  final SharedPref _sharedPref = SharedPref();

  Future<void> init(BuildContext context) async {
    this.context = context;
    await loginProvider.init(context);
  }

  void login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      MySnackbar.show(context, 'Debe ingresar todos los datos');
      return;
    }

    ResponseApi? responseApi = await loginProvider.login(username, password);
    // ignore: avoid_print
    print('REPUESTA: ${responseApi?.toJson()}');

    if (responseApi!.success != null && responseApi.success!) {
      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());
      await _registerToken(user.userId);
      Navigator.pushNamedAndRemoveUntil(
        context!,
        'home',
        (route) => false,
      );
      MySnackbar.show(context, responseApi.message!);
    } else {
      if (responseApi.message != null &&
          responseApi.message!.contains('Access Denied')) {
        MySnackbar.show(context, 'Usuario o contraseña incorrectos');
      } else {
        MySnackbar.show(context, responseApi.error!);
      }
    }
  }

  Future<void> _registerToken(int userId) async {
    final deviceToken = await _sharedPref.read('deviceToken');
    if (deviceToken != null) {
      registerTokenController.registerToken(
        DeviceToken(
          userId: userId,
          token: deviceToken,
        ),
      );
    }
  }
}
