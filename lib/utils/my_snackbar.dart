import 'package:flutter/material.dart';

import 'my_colors.dart';

class MySnackbar {
  static void show(BuildContext? context, String message) {
    if (context == null) {
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            // fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: MyColors.primarySwatch[600],
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
