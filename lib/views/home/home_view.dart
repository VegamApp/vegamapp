import 'package:flutter/material.dart';
import 'package:m2/utilities/widgets/scaffold_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static String route = '/';
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BuildScaffold(
      child: ListView(),
    );
  }
}
