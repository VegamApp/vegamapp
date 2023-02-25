import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/views/account_view/account_information_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSideBar extends StatefulWidget {
  const AccountSideBar({super.key, required this.currentPage, required this.scrollController});
  final String currentPage;
  final ScrollController scrollController;
  @override
  State<AccountSideBar> createState() => _AccountSideBarState();
}

class _AccountSideBarState extends State<AccountSideBar> {
  // final ScrollController _sidebarScroller = ScrollController();

  signOut() async {
    // clear all data of the logged in user and show logout screen
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    // loginToken.clearCartId();
    // loginToken.clearLoginToken();
    // print(loginToken.loginToken);
    // print(loginToken.cartId);
    // Phoenix.rebirth(context);
    // Navigator.pushAndRemoveUntil(context, PageTransition(child: const MyApp(signIn: true), type: PageTransitionType.fade), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AppResponsive(mobile: Scaffold(body: getScaffoldChild()), desktop: getScaffoldChild());
  }

  LayoutBuilder getScaffoldChild() {
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
                                child: Center(child: Text("J", style: AppStyles.getMediumTextStyle(fontSize: 50, color: Colors.white)))),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.buttonColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowColor,
                                    offset: const Offset(0, 5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset('assets/svg/camera.svg'),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(child: Text('Hi John Smitha', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.fontColor))),
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
                      isBold: widget.currentPage == AccountInformationView.route,
                    ),
                    BuilProfileButtons(
                      title: 'My Downloadable Products',
                      svgUrl: 'downloadable',
                      // child: const DownloadableProductsView(),
                      isBold: widget.currentPage == 'My Downloadable Products',
                    ),
                    BuilProfileButtons(
                      title: 'Address Book',
                      svgUrl: 'location_on',
                      // child: const AddressView(),
                      isBold: widget.currentPage == 'Address Book',
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
                      // child: const MyOrderView(),
                      isBold: widget.currentPage == 'My Orders',
                    ),
                    BuilProfileButtons(
                      title: 'My Wish List',
                      svgUrl: 'wishlist',
                      // child: const WishList(),
                      isBold: widget.currentPage == 'My Wish List',
                    ),
                    BuilProfileButtons(
                      title: 'Newsletter Subscriptions',
                      svgUrl: 'newsletter',
                      // child: const NewsletterSubView(),
                      isBold: widget.currentPage == 'Newsletter Subscriptions',
                    ),
                    BuilProfileButtons(
                      title: 'Stored Payment Methods',
                      svgUrl: 'payment',
                      // child: const StoredPayment(),
                      isBold: widget.currentPage == 'Stored Payment Methods',
                    ),
                    BuilProfileButtons(
                      title: 'Billing Agreements',
                      svgUrl: 'billing',
                      // child: const BillingAgreementsView(),
                      isBold: widget.currentPage == 'Billing Agreements',
                    ),
                    const BuilProfileButtons(
                      title: 'Need Help',
                      // child: ExamplePage(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                leading: SizedBox(height: 30, width: 30, child: SvgPicture.asset('assets/svg/sign_out.svg', color: AppColors.buttonColor)),
                title: Text('Sign Out', style: AppStyles.getRegularTextStyle(fontSize: 18, color: AppColors.fontColor)),
                onTap: signOut,
              ),
            ],
          ),
        );
      },
    );
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
  const BuilProfileButtons({Key? key, required this.title, this.svgUrl, this.child, this.isBold = false}) : super(key: key);
  final String title;
  final String? svgUrl;
  final Widget? child;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      selectedColor: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        leading: svgUrl != null
            ? SizedBox(height: 30, width: 30, child: SvgPicture.asset('assets/svg/$svgUrl.svg', color: AppColors.buttonColor))
            : const SizedBox(width: 30),
        title: Text(title,
            style: isBold
                ? AppStyles.getSemiBoldTextStyle(fontSize: 18, color: AppColors.fontColor)
                : AppStyles.getRegularTextStyle(fontSize: 18, color: AppColors.fontColor)),
        onTap: () {
          if (!isBold) {}
        },
      ),
    );
  }
}
