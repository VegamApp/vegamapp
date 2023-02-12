import 'package:flutter/material.dart';

class AppbarSearchService extends StatefulWidget {
  const AppbarSearchService({super.key});

  @override
  State<AppbarSearchService> createState() => _AppbarSearchServiceState();
}

class _AppbarSearchServiceState extends State<AppbarSearchService> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
    );
  }
}
