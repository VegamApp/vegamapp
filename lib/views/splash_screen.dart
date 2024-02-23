import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/views/auth/auth.dart';

// ! This page is no longer used and will be removed in the future
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String route = '/';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }

  navigateToPage() {
    Timer(const Duration(seconds: 5), () {
      GoRouter.of(context).pushReplacement(Auth.route);
    });
  }
}
