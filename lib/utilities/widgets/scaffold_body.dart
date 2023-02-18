import 'package:flutter/material.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/categories/categories_data.dart';
import 'package:m2/services/state_management/home/home_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/widgets/drawer.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:provider/provider.dart';

class BuildScaffold extends StatefulWidget {
  const BuildScaffold({super.key, required this.child});
  final Widget child;

  @override
  State<BuildScaffold> createState() => _BuildScaffoldState();
}

class _BuildScaffoldState extends State<BuildScaffold> {
  final key = GlobalKey<ScaffoldState>();

  getData(context) async {
    var cart = Provider.of<CartData>(context);
    var token = Provider.of<AuthToken>(context);
    var categories = Provider.of<CategoriesData>(context);
    var homeData = Provider.of<HomeData>(context);

    if (cart.cartId == null) {
      if (token.loginToken == null) {
        cart.getGuestCart(context);
      } else {
        cart.getCustomerCart(context);
      }
    } else {
      if (cart.cartData.isEmpty) {
        cart.getCartData(context);
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
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    getData(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: key,
      appBar: BuildAppBar(scaffoldKey: key, height: !AppResponsive.isDesktop(context) ? 60 : 200),
      body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1400), child: widget.child)),
      endDrawer: DrawerContainer(size: size),
    );
  }
}
