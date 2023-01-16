// import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/views/example.dart';
import 'package:m2/views/splash_screen.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    // GoRoute(
    //   path: "/home/:page",
    //   pageBuilder: (context, state) {
    //     return getCustomTransition(state, Home());
    //   },
    // ),
    GoRoute(
      path: SplashScreen.route,
      pageBuilder: (context, state) {
        return getCustomTransition(state, const SplashScreen());
      },
    ),
    GoRoute(
      path: ExPage.route,
      pageBuilder: (context, state) {
        return getCustomTransition(state, const ExPage());
      },
    ),
    // GoRoute(
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return getCustomTransition(state, SplashScreen());
    //   },
    // ),
    // GoRoute(
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return getCustomTransition(state, SplashScreen());
    //   },
    // ),
    // GoRoute(
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return getCustomTransition(state, SplashScreen());
    //   },
    // ),
    // GoRoute(
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return getCustomTransition(state, SplashScreen());
    //   },
    // ),
    // GoRoute(
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return getCustomTransition(state, SplashScreen());
    //   },
    // ),
    // GoRoute(
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return getCustomTransition(state, SplashScreen());
    //   },
    // ),
    // GoRoute(
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return getCustomTransition(state, SplashScreen());
    //   },
    // ),
  ],
);

CustomTransitionPage<dynamic> getCustomTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Change the opacity of the screen using a Curve based on the the animation's
      // value
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}
