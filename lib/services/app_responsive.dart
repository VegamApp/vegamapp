import 'package:flutter/material.dart';

// Widget to make the app responsive according to the size of the screen
class AppResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const AppResponsive({super.key, required this.mobile, this.tablet, required this.desktop});

  static bool isMobile(context) => MediaQuery.of(context).size.width < 700;
  static bool isTablet(context) => MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 700;
  static bool isDesktop(context) => MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
