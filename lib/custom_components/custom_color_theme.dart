import 'package:flutter/material.dart';

class CustomColorTheme {
  Map<int, Color> color = {
    50: Color.fromRGBO(64, 78, 92, .1),
    100: Color.fromRGBO(64, 78, 92, .2),
    200: Color.fromRGBO(64, 78, 92, .3),
    300: Color.fromRGBO(64, 78, 92, .4),
    400: Color.fromRGBO(64, 78, 92, .5),
    500: Color.fromRGBO(64, 78, 92, .6),
    600: Color.fromRGBO(64, 78, 92, .7),
    700: Color.fromRGBO(64, 78, 92, .8),
    800: Color.fromRGBO(64, 78, 92, .9),
    900: Color.fromRGBO(64, 78, 92, 1),
  };

  MaterialColor customColor() {
    return MaterialColor(0xFF404e5c, color);
  }

  static const Color selectionScreenBackground = Color(0xFF4F6272);
  static const Color selectionScreenAccent = Color(0xFF7BD389);
}
