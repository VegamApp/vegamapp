import 'package:flutter/cupertino.dart';

class AppStyles {
  static TextStyle getExtraLightTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: isCurrency ? null : "Poppins",
      color: color,
      fontWeight: FontWeight.w200,
    );
  }

  static TextStyle getLightTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: isCurrency ? null : "Poppins",
      color: color,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle getRegularTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: isCurrency ? null : "Poppins",
      color: color,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle getBoldTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: isCurrency ? null : "Poppins",
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle getSemiBoldTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: isCurrency ? null : "Poppins",
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle getMediumTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: isCurrency ? null : "Poppins",
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}

// List of various text styles used within the app

