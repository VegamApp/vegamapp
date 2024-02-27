import 'package:flutter/material.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:provider/provider.dart';

// ! This page is no longer used and will be removed in the future
class ExPage extends StatefulWidget {
  const ExPage({super.key});
  static String route = '/expage';
  @override
  State<ExPage> createState() => _ExPageState();
}

class _ExPageState extends State<ExPage> {
  @override
  Widget build(BuildContext context) {
    final authToken = Provider.of<AuthToken>(context);
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            setState(() {});
            // print(graphqlToken.);
            // await SharedPreferences.getInstance().then((value) => value.clear());
          },
          child: const Text("hi"),
        ),
      ),
    );
  }
}
