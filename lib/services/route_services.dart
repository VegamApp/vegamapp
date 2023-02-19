// import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/example.dart';
import 'package:m2/views/home/home_view.dart';
import 'package:m2/views/product_views/product_view.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
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
            print(state.queryParams);
            return getCustomTransition(
              state,
              ProductView(
                categoryId: state.queryParams['categoryId'],
                categoryUid: state.queryParams['categoryUid'],
                viewAll: state.queryParams['viewAll'] == 'true',
                searchQuery: state.queryParams['search'],
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
    key: UniqueKey(),
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
