import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/services/state_management/user/user_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/scaffold_body.dart';
import 'package:m2/views/account_view/account_information_view.dart';
import 'package:m2/views/account_view/address_view.dart';
import 'package:m2/views/account_view/downloadable_products_view.dart';
import 'package:m2/views/account_view/newsletter_view.dart';
import 'package:m2/views/account_view/orders_view.dart';
import 'package:m2/views/account_view/wishlist_view.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSideBar extends StatefulWidget {
  const AccountSideBar({super.key, required this.currentPage});
  final String currentPage;
  static String route = 'profile';
  @override
  State<AccountSideBar> createState() => _AccountSideBarState();
}

class _AccountSideBarState extends State<AccountSideBar> {
  // final ScrollController _sidebarScroller = ScrollController();
  late UserData user;
  signOut(BuildContext context) async {
    // clear all data of the logged in user and show logout screen

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sign Out?", style: AppStyles.getMediumTextStyle(fontSize: 16)),
        content: Text(
          "Are you sure you want to signout?",
          style: AppStyles.getRegularTextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppStyles.getMediumTextStyle(fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () async {
              //print(item);
              // Navigator.pop(context);

              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.clear();
              var cart = Provider.of<CartData>(context, listen: false);
              var token = Provider.of<AuthToken>(context, listen: false);

              cart.clearCartId();
              cart.putCartCount(0);
              token.clearLoginToken();
              token.putWishlistCount(0);

              context.go('/${Auth.route}');

              // runMutation({'cartId': cart.cartId, 'itemId': item['id']});
            },
            child: Text(
              'OK',
              style: AppStyles.getMediumTextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
    // Navigator.pushAndRemoveUntil(context, PageTransition(child: const MyApp(signIn: true), type: PageTransitionType.fade), (route) => false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<UserData>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return AppResponsive(
      mobile: BuildScaffold(currentIndex: 3, child: SingleChildScrollView(child: getScaffoldChild(context))),
      desktop: getScaffoldChild(context),
    );
  }

  Widget getScaffoldChild(context) {
    return Observer(builder: (context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              // controller: widget.scrollController,
              children: [
                const SizedBox(height: 20),
                getContainer(
                  constraints: constraints,
                  // height: constraints.maxWidth * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 125,
                        height: 125,
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                  width: 125,
                                  height: 125,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryColor,
                                    border: Border.all(color: AppColors.buttonColor, width: 5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadowColor,
                                        offset: const Offset(0, 5),
                                        blurRadius: 10,
                                      ),
                                    ],
                                    // image: DecorationImage(
                                    //   image: CachedNetworkImageProvider(imgUrl),
                                    // ),
                                  ),
                                  child: Center(child: Text(user.data.firstname?[0] ?? "", style: AppStyles.getMediumTextStyle(fontSize: 50, color: Colors.white)))),
                            ),
                            // Align(
                            //   alignment: Alignment.bottomRight,
                            //   child: Container(
                            //     height: 40,
                            //     width: 40,
                            //     padding: const EdgeInsets.all(10),
                            //     decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       color: AppColors.buttonColor,
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: AppColors.shadowColor,
                            //           offset: const Offset(0, 5),
                            //           blurRadius: 10,
                            //         ),
                            //       ],
                            //     ),
                            //     child: SvgPicture.asset('assets/svg/camera.svg'),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(child: Text('Hi ${user.data.firstname ?? "..."}', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.fontColor))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                getContainer(
                  constraints: constraints,
                  child: Column(
                    children: [
                      BuilProfileButtons(
                        title: 'My Account',
                        svgUrl: 'person',
                        // child: const AccountInformation(),
                        isBold: widget.currentPage == AccountInformationView.route && !AppResponsive.isMobile(context),
                        url: "/account/${AccountInformationView.route}",
                      ),
                      // BuilProfileButtons(
                      //   title: 'My Downloadable Products',
                      //   svgUrl: 'downloadable',
                      //   url: "/account/${DownloadableProductsView.route}",
                      //   isBold: widget.currentPage == DownloadableProductsView.route && !AppResponsive.isMobile(context),
                      // ),
                      BuilProfileButtons(
                        title: 'Address Book',
                        svgUrl: 'location_on',
                        isBold: widget.currentPage == AddressView.route && !AppResponsive.isMobile(context),
                        url: "/account/${AddressView.route}",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                getContainer(
                  constraints: constraints,
                  child: Column(
                    children: [
                      BuilProfileButtons(
                        title: 'My Orders',
                        svgUrl: 'orders',
                        url: "/account/${OrdersView.route}",
                        isBold: widget.currentPage == OrdersView.route && !AppResponsive.isMobile(context),
                      ),
                      BuilProfileButtons(
                        title: 'My Wish List',
                        svgUrl: 'wishlist',
                        url: "/account/${WishlistView.route}",
                        isBold: widget.currentPage == 'My Wish List' && !AppResponsive.isMobile(context),
                      ),
                      BuilProfileButtons(
                        title: 'Newsletter Subscriptions',
                        svgUrl: 'newsletter',
                        // child: const NewsletterSubView(),
                        url: "/account/${NewsletterView.route}",
                        isBold: widget.currentPage == NewsletterView.route && !AppResponsive.isMobile(context),
                      ),
                      // BuilProfileButtons(
                      //   title: 'Stored Payment Methods',
                      //   svgUrl: 'payment',
                      //   // child: const StoredPayment(),
                      //   isBold: widget.currentPage == 'Stored Payment Methods' && !AppResponsive.isMobile(context),
                      // ),
                      // BuilProfileButtons(
                      //   title: 'Billing Agreements',
                      //   svgUrl: 'billing',
                      //   url: "/account/${BillingAgreementsView.route}",
                      //   isBold: widget.currentPage == BillingAgreementsView.route && !AppResponsive.isMobile(context),
                      // ),
                      // const BuilProfileButtons(
                      //   title: 'Need Help',
                      //   // child: ExamplePage(),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  leading: SizedBox(height: 30, width: 30, child: SvgPicture.asset('assets/svg/sign_out.svg', color: AppColors.buttonColor)),
                  title: Text('Sign Out', style: AppStyles.getRegularTextStyle(fontSize: 18, color: AppColors.fontColor)),
                  onTap: () => signOut(context),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Container getContainer({required BoxConstraints constraints, required Widget child, double? height}) {
    return Container(
      width: constraints.maxWidth,
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 50, offset: const Offset(0, 10))],
      ),
      child: child,
    );
  }
}

class BuilProfileButtons extends StatelessWidget {
  const BuilProfileButtons({super.key, required this.title, this.svgUrl, this.child, this.isBold = false, this.url});
  final String title;
  final String? svgUrl;
  final Widget? child;
  final bool isBold;
  final String? url;
  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      selectedColor: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        leading: svgUrl != null ? SizedBox(height: 30, width: 30, child: SvgPicture.asset('assets/svg/$svgUrl.svg', color: AppColors.buttonColor)) : const SizedBox(width: 30),
        title: Text(title,
            style: isBold ? AppStyles.getSemiBoldTextStyle(fontSize: 18, color: AppColors.fontColor) : AppStyles.getRegularTextStyle(fontSize: 18, color: AppColors.fontColor)),
        onTap: () {
          log(url.toString());
          if (!isBold && url != null) {
            context.push(url!);
          }
        },
      ),
    );
  }
}
