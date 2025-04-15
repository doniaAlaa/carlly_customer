import 'package:flutter/material.dart';

class MainTheme {
  static const int mainColor = 0xFFA31F1F; // Deep Purple color

  static const MaterialColor primaryColor = MaterialColor(
    mainColor,
    <int, Color>{
      50: Color(0xFFFDE0E0),
      100: Color(0xFFF8BFBF),
      200: Color(0xFFF29292),
      300: Color(0xFFEB6666),
      400: Color(0xFFE13E3E),
      500: Color(mainColor),
      600: Color(0xFFCB1919),
      700: Color(0xFFC01414),
      800: Color(0xFFB70F0F),
      900: Color(0xFFA60808),
    },
  );
}


TextTheme get textTheme => textThemeF();

TextTheme textThemeF() {
  return ThemeData.light().textTheme;
}

final List<String> colorNames = [
  'Black',
  'Blue',
  'Brown',
  'Burgundy',
  'Gold',
  'Grey',
  'Orange',
  'Green',
  'Purple',
  'Red',
  'Silver',
  'Beige',
  'Tan',
  'Teal',
  'White',
  'Yellow',
];

final List<Color> colors = [
  Colors.black,
  Colors.blue,
  const Color(0xff964B00),
  const Color(0xff800020),
  const Color(0xffFFD700),
  Colors.grey,
  Colors.orange,
  Colors.green,
  Colors.purple,
  Colors.red,
  const Color(0xffC0C0C0),
  const Color(0xffF5F5DC),
  const Color(0xffD2B48C),
  Colors.teal,
  Colors.white,
  Colors.yellow,
];