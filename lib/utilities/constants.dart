import 'package:flutter/material.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:url_launcher/url_launcher.dart';

// navigate(BuildContext context, Widget child) =>
//     Navigator.push(context, PageTransition(child: child, type: PageTransitionType.fade, isIos: Platform.isIOS));

navigate(BuildContext context, String routeName, {var arguments}) => Navigator.pushNamed(context, routeName, arguments: arguments);

//Temp images
// List<Map<String, dynamic>> photosBig = List.generate(3, (index) => {'url': 'https://picsum.photos/400/560?random=$index'});

// List<Map<String, dynamic>> photosBanner = List.generate(3, (index) => {'image': 'https://picsum.photos/400/200?random=$index'});

// String placeholderVeg = 'https://www.fluentu.com/blog/english/wp-content/uploads/sites/4/2020/02/vegetables-name-in-english-3.jpg';

String currency = '₹';

// email validator for textformfields.
String? validateEmail(String? value) {
  RegExp regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (value == null || value.isEmpty || !regex.hasMatch(value)) {
    return 'Enter a valid email address';
  } else {
    return null;
  }
}

Future<void> launchPhone(String phoneNo) async {
  final Uri url = Uri.parse('tel://$phoneNo');

  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}

Future<void> openUrl(String link) async {
  final Uri url = Uri.parse(link);

  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}

showSnackBar(
    {required context, required String message, required Color backgroundColor, Color? textColor, Duration? duration, SnackBarBehavior? behavior}) {
  String? msg;
  if (message.contains("sku:")) {
    msg = "The requested qty is not available in this store.";
  } else {
    msg = message;
  }
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: behavior,
      duration: duration ?? const Duration(milliseconds: 3000),
      content: Text(msg, style: AppStyles.getRegularTextStyle(fontSize: 14, color: textColor ?? Colors.white)),
      backgroundColor: backgroundColor,
      dismissDirection: DismissDirection.startToEnd,
    ),
  );
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
