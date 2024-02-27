import 'package:flutter/material.dart';

import 'utilities.dart';

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

  static ButtonStyle filledButtonStyle = ButtonStyle(
    // fixedSize: Size(widget.width * 0.4, widget.width * 0.1),
    maximumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
    shape: MaterialStateProperty.all(StadiumBorder(side: BorderSide(color: AppColors.buttonColor, width: 2))),
    backgroundColor: MaterialStateProperty.resolveWith(getButtonColor),
    foregroundColor: MaterialStateProperty.resolveWith(getTextColor),
    padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
  );
  static ButtonStyle outlineButtonStyle = ButtonStyle(
    // fixedSize: Size(widget.width * 0.4, widget.width * 0.1),
    maximumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
    shape: MaterialStateProperty.all(StadiumBorder(side: BorderSide(color: AppColors.buttonColor, width: 2))),
    backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
    foregroundColor: MaterialStatePropertyAll(AppColors.primaryColor),
    padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
  );

  static List<BoxShadow> defaultShadow = [BoxShadow(color: AppColors.fadedText.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 3))];
}

// List of various text styles used within the app

