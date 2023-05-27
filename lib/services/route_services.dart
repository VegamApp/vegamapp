// import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/views/account_view/account_information_view.dart';
import 'package:m2/views/account_view/address_view.dart';
import 'package:m2/views/account_view/billing_agreement_view.dart';
import 'package:m2/views/account_view/downloadable_products_view.dart';
import 'package:m2/views/account_view/orders_view.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/auth/forgot_password.dart';
import 'package:m2/views/cart_views/cart_addresss_view.dart';
import 'package:m2/views/cart_views/cart_payment.dart';
import 'package:m2/views/cart_views/cart_view.dart';
import 'package:m2/views/cart_views/payment_complete_view.dart';
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
          path: ForgotPassword.route,
          pageBuilder: (context, state) {
            return getCustomTransition(state, const ForgotPassword());
          },
        ),
        GoRoute(
          path: '${ProductView.route}/:url',
          pageBuilder: (context, state) {
            return getCustomTransition(state, ProductView(urlKey: state.pathParameters['url']));
          },
        ),
        GoRoute(
          path: ProductView.route,
          pageBuilder: (context, state) {
            print(state.queryParameters);
            return getCustomTransition(
              state,
              ProductView(
                categoryId: state.queryParameters['categoryId'],
                categoryUid: state.queryParameters['categoryUid'],
                viewAll: state.queryParameters['viewAll'] == 'true',
                searchQuery: state.queryParameters['search'],
              ),
            );
          },
        ),
        GoRoute(
          path: 'account',
          pageBuilder: (context, state) {
            return getCustomTransition(state, const AccountInformationView());
          },
          routes: [
            GoRoute(
              path: AccountInformationView.route,
              pageBuilder: (context, state) {
                print(state.fullPath);
                return getCustomTransition(state, const AccountInformationView());
              },
            ),
            GoRoute(
              path: DownloadableProductsView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, const DownloadableProductsView());
              },
            ),
            GoRoute(
              path: AddressView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, const AddressView());
              },
            ),
            GoRoute(
              path: OrdersView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, const OrdersView());
              },
            ),
            GoRoute(
              path: BillingAgreementsView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, const BillingAgreementsView());
              },
            ),
          ],
        ),
        GoRoute(
            path: CartView.route,
            pageBuilder: (context, state) {
              return getCustomTransition(state, const CartView());
            },
            routes: [
              GoRoute(
                path: CartAddressView.route,
                pageBuilder: (context, state) {
                  return getCustomTransition(state, const CartAddressView());
                },
              ),
              GoRoute(
                path: CartPayment.route,
                pageBuilder: (context, state) {
                  return getCustomTransition(state, const CartPayment());
                },
              ),
              GoRoute(
                path: OrderPlacedView.route,
                pageBuilder: (context, state) {
                  return getCustomTransition(state, const OrderPlacedView());
                },
              ),
            ]),
      ],
    ),
    GoRoute(
      path: ExPage.route,
      pageBuilder: (context, state) {
        return getCustomTransition(state, const ExPage());
      },
    ),
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
