import 'package:flutter/material.dart';

class MyColors {
  
  static Color primaryColor = const Color(0xFF061B50);
  // static Color primaryAccent = const Color(0xFF335487);
  static Color secondaryColor = const Color(0xFF05499B);
  static Color primaryColorDark = const Color(0xFF04133B);
  
  static MaterialColor primarySwatch = const MaterialColor(
    0xFF061B50,
    <int, Color>{
      50: Color(0xFFE3EBF5),
      100: Color(0xFFB3CCE8),
      200: Color(0xFF7DA4D6),
      300: Color(0xFF4D80C6),
      400: Color(0xFF255EB7),
      500: Color(0xFF061B50), // Este es el color primario
      600: Color(0xFF051845),
      700: Color(0xFF04133B),
      800: Color(0xFF030F30),
      900: Color(0xFF020B26),
    },
  );
  
  static Color primaryOpacityColor = const Color.fromRGBO(6, 27, 80, 0.9);
}
