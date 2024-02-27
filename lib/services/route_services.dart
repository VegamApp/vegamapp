// import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/utilities/widgets/account_sidebar.dart';
import 'package:m2/views/account_view/account_information_view.dart';
import 'package:m2/views/account_view/address_view.dart';
import 'package:m2/views/account_view/billing_agreement_view.dart';
import 'package:m2/views/account_view/downloadable_products_view.dart';
import 'package:m2/views/account_view/my_order_detail_view.dart';
import 'package:m2/views/account_view/newsletter_view.dart';
import 'package:m2/views/account_view/orders_view.dart';
import 'package:m2/views/account_view/wishlist_view.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/auth/forgot_password.dart';
import 'package:m2/views/cart_views/cart_addresss_view.dart';
import 'package:m2/views/cart_views/cart_payment.dart';
import 'package:m2/views/cart_views/cart_view.dart';
import 'package:m2/views/cart_views/payment_complete_view.dart';
import 'package:m2/views/cms_view.dart';
import 'package:m2/views/contact_view.dart';
import 'package:m2/views/example.dart';
import 'package:m2/views/home/home_view.dart';
import 'package:m2/views/home/search_view.dart';
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
          path: SearchView.route,
          name: SearchView.route,
          pageBuilder: (context, state) {
            return getCustomTransition(state, const SearchView());
          },
        ),
        GoRoute(
          path: Auth.route,
          name: Auth.route,
          pageBuilder: (context, state) {
            return getCustomTransition(state, const Auth());
          },
        ),
        GoRoute(
          name: ForgotPassword.route,
          path: ForgotPassword.route,
          pageBuilder: (context, state) {
            return getCustomTransition(state, const ForgotPassword());
          },
        ),
        GoRoute(
          // name: ProductView.route,
          path: '${ProductView.route}/:url',
          pageBuilder: (context, state) {
            return getCustomTransition(state, ProductView(urlKey: state.pathParameters['url']));
          },
        ),
        GoRoute(
          name: ProductView.route,
          path: ProductView.route,
          pageBuilder: (context, state) {
            print(state.uri.queryParameters);
            return getCustomTransition(
              state,
              ProductView(
                categoryId: state.uri.queryParameters['categoryId'],
                categoryUid: state.uri.queryParameters['categoryUid'],
                viewAll: state.uri.queryParameters['viewAll'] == 'true',
                searchQuery: state.uri.queryParameters['search'],
              ),
            );
          },
        ),
        GoRoute(
          name: 'account',
          path: 'account',
          pageBuilder: (context, state) {
            return getCustomTransition(state, AccountSideBar(currentPage: AccountInformationView.route));
          },
          routes: [
            GoRoute(
              name: AccountInformationView.route,
              path: AccountInformationView.route,
              pageBuilder: (context, state) {
                print(state.fullPath);
                return getCustomTransition(state, const AccountInformationView());
              },
            ),
            GoRoute(
              name: WishlistView.route,
              path: WishlistView.route,
              pageBuilder: (context, state) {
                print(state.fullPath);
                return getCustomTransition(state, const WishlistView());
              },
            ),
            GoRoute(
              name: DownloadableProductsView.route,
              path: DownloadableProductsView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, const DownloadableProductsView());
              },
            ),
            GoRoute(
              path: AddressView.route,
              name: AddressView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, const AddressView());
              },
            ),
            GoRoute(
              path: OrdersView.route,
              name: OrdersView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, const OrdersView());
              },
            ),
            GoRoute(
              path: NewsletterView.route,
              name: NewsletterView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, const NewsletterView());
              },
            ),
            GoRoute(
              path: '${OrdersView.route}/:id',
              // name: OrdersView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, MyOrderDetailView(orderId: state.pathParameters['id']!));
              },
            ),
            GoRoute(
              path: BillingAgreementsView.route,
              name: BillingAgreementsView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, const BillingAgreementsView());
              },
            ),
          ],
        ),
        GoRoute(
          path: CartView.route,
          name: CartView.route,
          pageBuilder: (context, state) {
            return getCustomTransition(state, const CartView());
          },
          routes: [
            GoRoute(
              path: CartAddressView.route,
              name: CartAddressView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, const CartAddressView());
              },
            ),
            GoRoute(
              path: CartPayment.route,
              name: CartPayment.route,
              pageBuilder: (context, state) {
                return getCustomTransition(state, const CartPayment());
              },
            ),
            GoRoute(
              path: OrderPlacedView.route,
              name: OrderPlacedView.route,
              pageBuilder: (context, state) {
                return getCustomTransition(
                  state,
                  OrderPlacedView(
                    orderId: state.uri.queryParameters['orderid'],
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: CmsView.route,
          name: CmsView.route,
          pageBuilder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return getCustomTransition(state, CmsView(id: id));
          },
        ),
        GoRoute(
          path: ContactView.route,
          name: ContactView.route,
          pageBuilder: (context, state) {
            return getCustomTransition(state, const ContactView());
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
