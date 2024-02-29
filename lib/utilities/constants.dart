
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gql/ast.dart';

String logoUrl = 'assets/images/logo.png';
String currency = '\$';

enum Gender { male, female }

//Temp images
// List<Map<String, dynamic>> photosBig = List.generate(3, (index) => {'url': 'https://picsum.photos/400/560?random=$index'});

// List<Map<String, dynamic>> photosBanner = List.generate(3, (index) => {'image': 'https://picsum.photos/400/200?random=$index'});

// email validator for textformfields.
String? validateEmail(String? value) {
  RegExp regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (value == null || value.isEmpty || !regex.hasMatch(value)) {
    return 'Enter a valid email address';
  } else {
    return null;
  }
}

Color getButtonColor(Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) {
    return AppColors.scaffoldColor;
  }
  return AppColors.buttonColor;
}

Color getTextColor(Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) {
    return AppColors.buttonColor;
  }
  return AppColors.buttonTextColor;
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

showSnackBar({required context, required String message, required Color backgroundColor, Color? textColor, Duration? duration, SnackBarBehavior? behavior}) {
  String? msg;
  if (message.contains("sku:")) {
    msg = "The requested qty is not available in this store.";
  } else {
    msg = message;
  }
  print(message);

  if (AppResponsive.isMobile(context)) {
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
  return Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM_RIGHT,
    backgroundColor: backgroundColor,
    textColor: textColor,
    timeInSecForIosWeb: 2,
    // webBgColor: "linear-gradient(to right, #31ACA0, #187B71)",
  );
}

showDeleteDialog(BuildContext context, {required String type, required Function() onDelete}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Delete this $type?", style: AppStyles.getSemiBoldTextStyle(fontSize: 16)),
            content: Text("Are you sure you want to delete this ${type.toLowerCase()}?. This action cannot be undone."),
            actions: [
              TextButton(onPressed: onDelete, child: Text("Delete", style: AppStyles.getMediumTextStyle(fontSize: 14))),
              TextButton(onPressed: () => context.pop(), child: Text("Cancel", style: AppStyles.getMediumTextStyle(fontSize: 14))),
            ],
          );
        },
      );
    },
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

DocumentNode addFragments(DocumentNode doc, List<DocumentNode> fragments) {
  final newDefinitions = Set<DefinitionNode>.from(doc.definitions);
  for (final frag in fragments) {
    newDefinitions.addAll(frag.definitions);
  }
  return DocumentNode(definitions: newDefinitions.toList(), span: doc.span);
}
