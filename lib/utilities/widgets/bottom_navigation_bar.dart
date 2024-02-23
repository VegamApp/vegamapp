import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/cart_views/cart_view.dart';
import 'package:m2/views/home/search_view.dart';
import 'package:provider/provider.dart';

class BuildBottomNavBar extends StatelessWidget {
  const BuildBottomNavBar({super.key, required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var cart = Provider.of<CartData>(context);
    return SizedBox(
      width: size.width,
      height: 74,
      child: Row(
        children: [
          getIcon(
              size,
              currentIndex == 0
                  ? Icon(Icons.home_filled, color: AppColors.primaryColor)
                  : SvgPicture.asset('assets/svg/home.svg', color: currentIndex == 0 ? AppColors.kPrimaryColor : Colors.black),
              0,
              context),
          getIcon(
              size,
              currentIndex == 1
                  ? Icon(Icons.search_sharp, color: AppColors.primaryColor)
                  : SvgPicture.asset('assets/svg/search.svg', color: currentIndex == 1 ? AppColors.kPrimaryColor : Colors.black),
              1,
              context),
          getIcon(
            size,
            Observer(builder: (context) {
              return SizedBox(
                width: size.width * 0.1,
                child: Stack(
                  children: [
                    Center(
                        child: currentIndex == 2
                            ? Icon(Icons.shopping_cart, color: AppColors.primaryColor)
                            : SvgPicture.asset('assets/svg/cart.svg', color: currentIndex == 2 ? AppColors.kPrimaryColor : Colors.black)),
                    if (cart.cartCount != 0)
                      Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          backgroundColor: AppColors.buttonColor,
                          radius: 7.5,
                          child: Text(cart.cartCount.toString(), style: AppStyles.getRegularTextStyle(fontSize: 9, color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              );
            }),
            2,
            context,
          ),
          getIcon(
              size,
              currentIndex == 3
                  ? Icon(Icons.person, color: AppColors.primaryColor)
                  : SvgPicture.asset('assets/svg/person.svg', color: currentIndex == 3 ? AppColors.kPrimaryColor : Colors.black),
              3,
              context),
        ],
      ),
    );
  }

  SizedBox getIcon(Size size, Widget child, int index, BuildContext context) {
    return SizedBox(
      width: size.width * 0.25,
      height: 40,
      child: IconButton(
        onPressed: () {
          if (currentIndex != index) {
            navigate(index, context);
          }
        },
        icon: child,
      ),
    );
  }

  navigate(int index, BuildContext context) {
    switch (index) {
      case 0:
        return context.push("/");
      case 1:
        return context.push('/${SearchView.route}');
      case 2:
        return context.push("/${CartView.route}");
      case 3:
        final authToken = Provider.of<AuthToken>(context, listen: false);
        if (authToken.loginToken == null) {
          return context.push('/${Auth.route}');
        } else {
          return context.push('/account');
        }

      default:
        break;
    }
  }
}
