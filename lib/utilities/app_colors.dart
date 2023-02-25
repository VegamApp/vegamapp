import 'package:flutter/material.dart';

class AppColors {
  static Color kPrimaryColor = const Color(0xff0E887C); //Primary color of the app

  static LinearGradient gradient = const LinearGradient(
      colors: [Color(0xff31ACA0), Color(0xff187B71)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter); // A common gradient throughout the app

  static Color fadedText = const Color(0xff707070); // Faded text color
  static Color evenFadedText = const Color(0xffc5c5c5); // Even faded text color.
  static Color lessFadedText = const Color(0xff4A4A4A);
  static Color fontColor = Colors.black; // Font color (usually black)

  static Color defaultBackground = const Color.fromRGBO(115, 115, 155, 0.15);

  static Color fadedContainerColor = const Color(0x14c5c5c5);
  static Color shadowColor = const Color.fromRGBO(0, 0, 0, 0.04);
  static Color containerColor = Colors.white;

  static Color appBarColor = Colors.white;

  static Color scaffoldColor = Colors.white; // Main background color

  static Color buttonColor = const Color(0xff31aca0); // Color of buttons throughout the app
  static Color buttonTextColor = Colors.white;

  static Color facebookBlue = const Color(0xff4267B2);
  static Color googleRed = const Color(0xffdb4a39);

  static Color dividerColor = const Color(0xffEFEFEF);

  static Color textFieldColor = const Color(0xffE9F1F4);

  static Color blogText = const Color(0xff103F50);

  static Color snackbarSuccessBackgroundColor = Colors.green;
  static Color snackbarSuccessTextColor = Colors.white;
  static Color snackbarErrorBackgroundColor = Colors.red;
  static Color snackbarErrorTextColor = Colors.white;

  static Map<int, Color> color = const {
    50: Color.fromRGBO(14, 136, 124, 0.1),
    100: Color.fromRGBO(14, 136, 124, 0.2),
    200: Color.fromRGBO(14, 136, 124, 0.3),
    300: Color.fromRGBO(14, 136, 124, 0.4),
    400: Color.fromRGBO(14, 136, 124, 0.5),
    500: Color.fromRGBO(14, 136, 124, 0.6),
    600: Color.fromRGBO(14, 136, 124, 0.7),
    700: Color.fromRGBO(14, 136, 124, 0.8),
    800: Color.fromRGBO(14, 136, 124, 0.9),
    900: Color.fromRGBO(14, 136, 124, 1),
  };
  static MaterialColor primaryColor = MaterialColor(0xff0E887C, color); // Material color version of primary color for integrating to flutter
}
