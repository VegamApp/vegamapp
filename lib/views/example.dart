import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:provider/provider.dart';

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
    final graphqlToken = GraphQLProvider.of(context);
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            authToken.putLoginToken('Jabaaa');
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
