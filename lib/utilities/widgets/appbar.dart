import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:m2/services/api_services/cart_apis.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/categories/categories_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/services/state_management/user/user_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/appbar_searchfield.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/account_view/account_information_view.dart';
import 'package:m2/views/account_view/orders_view.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/cart_views/cart_view.dart';
import 'package:m2/views/home/home_view.dart';
import 'package:m2/views/product_views/product_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class BuildAppBar extends StatelessWidget implements PreferredSize {
  BuildAppBar({super.key, required this.scaffoldKey, this.height});
  final GlobalKey<ScaffoldState> scaffoldKey;
  double? height;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: AppResponsive.isDesktop(context) ? 160 : 60,
        width: size.width,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 5, offset: const Offset(0, 3))],
          color: AppColors.appBarColor,
        ),
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: AppResponsive(
            desktop: Row(
              children: [
                getHomeButton(size),
                // const SizedBox(width: 50),
                // const DeliveryHoverWidget(),
                const Expanded(
                  child: AppbarCategories(),
                )
              ],
            ),
            mobile: Row(
              children: [
                getHomeButton(size),
                const Spacer(),
                InkWell(
                  onTap: () => scaffoldKey.currentState?.openEndDrawer(),
                  child: SizedBox(
                    width: 40,
                    child: Icon(Icons.menu, color: AppColors.fadedText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getHomeButton(Size size) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => context.go(HomeView.route),
        child: SizedBox(
          width: size.width * 0.2 > 100 ? 100 : size.width * 0.2,
          height: size.width * 0.2 > 100 ? 100 : size.width * 0.2,
          child: Align(alignment: Alignment.centerLeft, child: Image.asset(logoUrl)),
        ),
      );
    });
  }

  @override
  Widget get child => AppBar();

  @override
  Size get preferredSize => Size.fromHeight(height ?? 140);
}

class AppbarCategories extends StatefulWidget {
  const AppbarCategories({super.key});

  @override
  State<AppbarCategories> createState() => _AppbarCategoriesState();
}

class _AppbarCategoriesState extends State<AppbarCategories> {
  bool cartPortalTarget = false;
  bool userPortalTarget = false;
  var f = NumberFormat("#,##,##,##0.00", "en_IN");

  @override
  Widget build(BuildContext context) {
    var categories = Provider.of<CategoriesData>(context);
    var cart = Provider.of<CartData>(context);
    var authToken = Provider.of<AuthToken>(context);
    var userData = Provider.of<UserData>(context);

    return Observer(
      builder: (context) {
        if (categories.data.isNotEmpty && categories.data['categories']['items'][0]['children'].isNotEmpty && categories.portalTargets.isEmpty) {
          categories.populateTargets();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Generate button from api list
            if (categories.data.isNotEmpty)
              ...List.generate(
                categories.data['categories']['items'][0]['children'].length,
                (index) {
                  if (categories.data['categories']['items'][0]['children'][index]['include_in_menu'] == 0) {
                    return const SizedBox();
                  }
                  return categories.data['categories']['items'][0]['children'][index]['children'] == null ||
                          categories.data['categories']['items'][0]['children'][index]['children'].isEmpty
                      ? InkWell(
                          onTap: () {
                            print(categories.data['categories']['items'][0]['children'][index]);
                            context.goNamed(
                              ProductView.route,
                              queryParameters: {'categoryUid': categories.data['categories']['items'][0]['children'][index]['uid']},
                            );
                            // context.push(
                            //     '/${ProductView.route}/${categories.data['categories']['items'][0]['children'][index]['url_key']}${categories.data['categories']['items'][0]['children'][index]['url_suffix']}');
                          },
                          child: Container(
                            height: 50,
                            constraints: const BoxConstraints(minWidth: 50),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            child: Text(
                              categories.data['categories']['items'][0]['children'][index]['name'],
                              style: AppStyles.getMediumTextStyle(fontSize: 14),
                            ),
                          ),
                        )
                      : PortalTarget(
                          visible: categories.portalTargets[index],
                          anchor: const Aligned(
                            follower: Alignment.topCenter,
                            target: Alignment.bottomCenter,
                            shiftToWithinBound: AxisFlag(x: true, y: true),
                          ),
                          // anchor: Filled(),
                          portalFollower: MouseRegion(
                            onEnter: (event) => categories.editTargets(index),
                            onExit: (event) => categories.populateTargets(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              constraints: const BoxConstraints(maxWidth: 500),
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: AppColors.scaffoldColor,
                                boxShadow: [
                                  BoxShadow(color: AppColors.fadedText.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 3)),
                                ],
                              ),
                              // height: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  categories.data['categories']['items'][0]['children'][index]['children'].length,
                                  (index2) {
                                    if (categories.data['categories']['items'][0]['children'][index]['children'][index2]['include_in_menu'] == "0") {
                                      return const SizedBox();
                                    }
                                    return ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 200),
                                      child: categories.data['categories']['items'][0]['children'][index]['children'][index2]['children'] == null ||
                                              categories.data['categories']['items'][0]['children'][index]['children'][index2]['children'].isEmpty
                                          ? ListTile(
                                              onTap: () {
                                                setState(() => categories.portalTargets[index] = false);
                                                print(categories.data['categories']['items'][0]['children'][index]['children'][index2]);
                                                context.goNamed(
                                                  ProductView.route,
                                                  queryParameters: {'categoryUid': categories.data['categories']['items'][0]['children'][index]['children'][index2]['uid']},
                                                );
                                                // context.go(
                                                //     '/${ProductView.route}?category_uid=${categories.data['categories']['items'][0]['children'][index]['children'][index2]['uid']}');

                                                // print(categories.data['categories']['items'][0]['children'][index]['children'][index2]);
                                              },
                                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                              title: Text(
                                                categories.data['categories']['items'][0]['children'][index]['children'][index2]['name'],
                                                style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.fadedText),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                setState(() => categories.portalTargets[index] = false);

                                                print("expand: ${categories.data['categories']['items'][0]['children'][index]['children'][index2]}");
                                              },
                                              child: ExpansionTile(
                                                initiallyExpanded: true,
                                                title: Text(
                                                  categories.data['categories']['items'][0]['children'][index]['children'][index2]['name'],
                                                  style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.fadedText),
                                                ),
                                              ),
                                            ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          child: MouseRegion(
                            onEnter: (event) {
                              // print(categories.data['categories']['items'][0]['children'][index]);
                              categories.editTargets(index);
                            },
                            onExit: (event) {
                              categories.populateTargets();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                categories.data['categories']['items'][0]['children'][index]['name'],
                                style: AppStyles.getMediumTextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        );
                },
              ),
            const SizedBox(width: 10),

            // Search bar
            Container(
              // margin: const EdgeInsets.only(top: 20),
              constraints: const BoxConstraints(maxWidth: 300),
              child: const AppbarSearchService(),
            ),
            const SizedBox(width: 20),

            // cart button
            PortalTarget(
              visible: cart.cartCount != 0 && cart.cartData['cart']?['items']! != null && cartPortalTarget,
              anchor: const Aligned(
                follower: Alignment(0.5, -1.0),
                target: Alignment.bottomCenter,
                shiftToWithinBound: AxisFlag(x: true, y: true),
              ),
              // anchor: Filled(),
              portalFollower: cart.cartCount == 0 || cart.cartData['cart']?['items'] == null
                  ? null
                  : MouseRegion(
                      onEnter: (event) => setState(() => cartPortalTarget = true),
                      onExit: (event) => setState(() => cartPortalTarget = false),
                      child: Container(
                        width: 400,
                        // height: 200,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        constraints: const BoxConstraints(maxWidth: 500),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldColor,
                          boxShadow: [
                            BoxShadow(color: AppColors.fadedText.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 3)),
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          // mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Cart Subtotal: ${cart.cartData['cart']['prices']['subtotal_including_tax']['currency']} ${double.parse(cart.cartData['cart']['prices']['subtotal_including_tax']['value'].toString()).toStringAsFixed(2)}",
                                  style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.fadedText),
                                ),
                                Text(
                                  "${cart.cartCount} Item(s)",
                                  style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.fadedText),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cart.cartData['cart']['items'].length,
                              separatorBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Divider(color: AppColors.dividerColor),
                              ),
                              itemBuilder: (context, index) {
                                var item = cart.cartData['cart']['items'][index];
                                // return InkWell(
                                //   onTap: () => print(item),
                                //   child: Container(color: AppColors.primaryColor, height: 20),
                                // );
                                return Row(
                                  children: [
                                    SizedBox(height: 100, child: CachedNetworkImage(imageUrl: item['product']['image']['url'])),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item['product']['name'], style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.fontColor)),
                                          const SizedBox(height: 10),
                                          BuildPriceWithOffer(
                                            price: f.format(item['product']['price_range']['minimum_price']['regular_price']['value']),
                                            priceSize: 15,
                                            currency: item['product']['price_range']['minimum_price']['regular_price']['currency'],
                                          ),
                                          Mutation(
                                              options: MutationOptions(
                                                document: gql(CartApis.removeProductsFromCart),
                                                onCompleted: (data) async {
                                                  print(data); // cartData.checkVirtualCart();
                                                  showSnackBar(
                                                      context: context,
                                                      message: "Removed item from cart",
                                                      backgroundColor: AppColors.snackbarSuccessBackgroundColor,
                                                      textColor: AppColors.snackbarSuccessTextColor);
                                                  cart.getCartData(context, authToken);
                                                },
                                                onError: (error) {
                                                  showSnackBar(
                                                    context: context,
                                                    message: error!.graphqlErrors[0].message,
                                                    backgroundColor: AppColors.snackbarErrorBackgroundColor,
                                                    textColor: AppColors.snackbarErrorTextColor,
                                                  );

                                                  print(error);
                                                },
                                              ),
                                              builder: (runMutation, result) {
                                                return IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text("Delete?", style: AppStyles.getMediumTextStyle(fontSize: 16)),
                                                        content: Text(
                                                          "Are you sure you want to delete this item from cart?",
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
                                                            onPressed: () {
                                                              //print(item);
                                                              Navigator.pop(context);
                                                              runMutation({'cartId': cart.cartId, 'itemId': item['id']});
                                                            },
                                                            child: Text(
                                                              'OK',
                                                              style: AppStyles.getMediumTextStyle(fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  icon: Icon(Icons.delete_outline, color: AppColors.primaryColor),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              style: AppStyles.filledButtonStyle,
                              onPressed: () {
                                context.goNamed(CartView.route);
                              },
                              child: Text("View Cart", style: AppStyles.getMediumTextStyle(fontSize: 14)),
                            )
                          ],
                        ),
                      ),
                    ),
              child: MouseRegion(
                onEnter: (event) {
                  setState(() => cartPortalTarget = true);
                  cart.getCartData(context, authToken);
                },
                onExit: (event) => setState(() => cartPortalTarget = false),
                child: InkWell(
                  onTap: () {
                    context.goNamed(CartView.route);
                  },
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: AppColors.buttonColor)),
                            alignment: Alignment.center,
                            child: FaIcon(FontAwesomeIcons.basketShopping, color: AppColors.buttonColor, size: 15),
                          ),
                        ),
                        if (cart.cartCount != 0)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              backgroundColor: AppColors.buttonColor,
                              radius: 7.5,
                              child: Text(cart.cartCount.toString(), style: AppStyles.getRegularTextStyle(fontSize: 9, color: Colors.white)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),

            // user button
            PortalTarget(
              visible: userPortalTarget,
              anchor: const Aligned(
                follower: Alignment(0.5, -1.0),
                target: Alignment.bottomCenter,
                shiftToWithinBound: AxisFlag(x: true, y: true),
              ),
              // anchor: Filled(),
              portalFollower: MouseRegion(
                onEnter: (event) => setState(() => userPortalTarget = true),
                onExit: (event) => setState(() => userPortalTarget = false),
                child: Container(
                  width: 200,
                  // height: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  constraints: const BoxConstraints(maxWidth: 500),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldColor,
                    boxShadow: [
                      BoxShadow(color: AppColors.fadedText.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: authToken.loginToken == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: authToken.loginToken == null
                        ? [
                            TextButton(
                              style: ButtonStyle(
                                // fixedSize: Size(widget.width * 0.4, widget.width * 0.1),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    side: BorderSide(color: AppColors.buttonColor, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.resolveWith(getButtonColor),
                                foregroundColor: MaterialStateProperty.resolveWith(getTextColor),
                                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
                              ),
                              onPressed: () {
                                context.go('/${Auth.route}');
                              },
                              child: Text("Log in", style: AppStyles.getRegularTextStyle(fontSize: 14)),
                            )
                          ]
                        : [
                            Text(
                              "Hi ${userData.data.firstname} ${userData.data.lastname}",
                              style: AppStyles.getSemiBoldTextStyle(
                                fontSize: 14,
                                color: AppColors.fontColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Divider(color: AppColors.dividerColor, height: 1),
                            const SizedBox(height: 10),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                context.go('/account/${AccountInformationView.route}');
                              },
                              icon: SvgPicture.asset('assets/svg/person.svg', color: AppColors.fadedText, height: 20),
                              label: Text("My Account", style: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.fadedText)),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                context.go("/account/${OrdersView.route}");
                              },
                              icon: SvgPicture.asset('assets/svg/orders.svg', color: AppColors.fadedText, height: 20),
                              label: Text("Orders", style: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.fadedText)),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                // context.go("/account/${OrdersView.route}");
                              },
                              icon: SvgPicture.asset('assets/svg/wishlist.svg', color: AppColors.fadedText, height: 20),
                              label: Text("Wishlist", style: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.fadedText)),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              icon: SvgPicture.asset('assets/svg/sign_out.svg', color: AppColors.fadedText, height: 20),
                              onPressed: () => signOut(context),
                              label: Text("Sign out", style: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.fadedText)),
                            ),
                          ],
                  ),
                ),
              ),
              child: MouseRegion(
                onEnter: (event) => setState(() => userPortalTarget = true),
                onExit: (event) => setState(() => userPortalTarget = false),
                child: InkWell(
                  onTap: () {
                    if (authToken.loginToken == null) {
                      context.go('/${Auth.route}');
                    } else {
                      context.go('/account/${AccountInformationView.route}');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.buttonTextColor,
                      border: Border.all(color: AppColors.buttonColor, width: 2.5),
                      // image: DecorationImage(image: CachedNetworkImageProvider(imgUrl)),
                      shape: BoxShape.circle,
                    ),
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    child:
                        // user.firstname != null
                        //     ? Text(user.firstname![0], style: AppStyles.getMediumTextStyle(fontSize: 16, color: Colors.white))
                        // :
                        FaIcon(FontAwesomeIcons.userLarge, color: AppColors.buttonColor, size: 15),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  signOut(BuildContext context) async {
    // clear all data of the logged in user and show logout screen
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    var cart = Provider.of<CartData>(context, listen: false);
    var token = Provider.of<AuthToken>(context, listen: false);

    cart.clearCartId();
    cart.putCartCount(0);
    token.clearLoginToken();
    token.putWishlistCount(0);

    context.go('/${Auth.route}');
    // Navigator.pushAndRemoveUntil(context, PageTransition(child: const MyApp(signIn: true), type: PageTransitionType.fade), (route) => false);
  }
}
