import 'package:flutter/material.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/state_management/cache_clear/cache_manager.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/categories/categories_data.dart';
import 'package:m2/services/state_management/home/home_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/services/state_management/user/user_data.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:provider/provider.dart';

class BuildScaffold extends StatefulWidget {
  const BuildScaffold({super.key, required this.child, this.currentIndex = -1});
  final Widget child;
  final int currentIndex;
  @override
  State<BuildScaffold> createState() => _BuildScaffoldState();
}

class _BuildScaffoldState extends State<BuildScaffold> {
  final key = GlobalKey<ScaffoldState>();

  getData(context) async {
    var cart = Provider.of<CartData>(context, listen: false);
    var token = Provider.of<AuthToken>(context, listen: false);
    var categories = Provider.of<CategoriesData>(context, listen: false);
    var homeData = Provider.of<HomeData>(context, listen: false);
    var userData = Provider.of<UserData>(context, listen: false);
    var cacheManager = Provider.of<CacheManager>(context, listen: false);
    cacheManager.checkCache(context);

    if (cart.cartId == null) {
      if (token.loginToken == null) {
        cart.getGuestCart(context);
      } else {
        cart.getCustomerCart(context, token);
      }
    } else {
      if (cart.cartData.isEmpty) {
        cart.getCartData(context, token);
      }
    }
    if (token.loginToken != null && userData.data.email == null) {
      bool valid = await userData.getUserData(context);
      if (!valid) {
        token.clearLoginToken();
        token.putWishlistCount(0);
      }
    }
    if (categories.data.isEmpty || categories.data['categories']['items'].isEmpty) {
      categories.getCategoryData(context);
    }
    if (homeData.data.isEmpty) {
      homeData.getHomeData(context);
    }
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>);
    WidgetsBinding.instance.addPostFrameCallback((_) => getData(context));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // getData(context);

    return SafeArea(
      child: Scaffold(
        key: key,
        appBar: BuildAppBar(scaffoldKey: key, height: !AppResponsive.isDesktop(context) ? 60 : 120),
        body: widget.child,
        endDrawer: DrawerContainer(size: size),
        bottomNavigationBar: AppResponsive.isDesktop(context) ? null : BuildBottomNavBar(currentIndex: widget.currentIndex),
      ),
    );
  }
}
