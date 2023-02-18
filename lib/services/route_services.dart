// import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/example.dart';
import 'package:m2/views/home/home_view.dart';
import 'package:m2/views/product_views/product_view.dart';
import 'package:m2/views/splash_screen.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/products/carina-basic-capri.html',
  routes: [
    // GoRoute(
    //   path: "/home/:page",
    //   pageBuilder: (context, state) {
    //     return getCustomTransition(state, Home());
    //   },
    // ),
    GoRoute(
      path: HomeView.route,
      pageBuilder: (context, state) {
        return getCustomTransition(state, const HomeView());
      },
      routes: [
        GoRoute(
          path: Auth.route,
          pageBuilder: (context, state) {
            return getCustomTransition(state, const Auth());
          },
        ),
        GoRoute(
          path: '${ProductView.route}/:url',
          pageBuilder: (context, state) {
            return getCustomTransition(state, ProductView(urlKey: state.params['url']));
          },
        ),
        GoRoute(
          path: ProductView.route,
          pageBuilder: (context, state) {
            return getCustomTransition(
              state,
              ProductView(
                categoryId: state.params['categoryId'],
                categoryUid: state.params['categoryUid'],
                viewAll: state.params['viewAll'] == 'true',
                searchQuery: state.params['search'],
              ),
            );
          },
        ),
      ],
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
