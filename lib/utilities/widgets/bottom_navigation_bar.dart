import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/views/account_view/account_information_view.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/cart_views/cart_view.dart';
import 'package:provider/provider.dart';

class BuildBottomNavBar extends StatelessWidget {
  const BuildBottomNavBar({super.key, required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 74,
      child: Row(
        children: [
          getIcon(size, SvgPicture.asset('assets/svg/home.svg', color: currentIndex == 0 ? AppColors.kPrimaryColor : Colors.black), 0, context),
          getIcon(size, SvgPicture.asset('assets/svg/search.svg', color: currentIndex == 1 ? AppColors.kPrimaryColor : Colors.black), 1, context),
          getIcon(size, SvgPicture.asset('assets/svg/cart.svg', color: currentIndex == 2 ? AppColors.kPrimaryColor : Colors.black), 2, context),
          getIcon(size, SvgPicture.asset('assets/svg/person.svg', color: currentIndex == 3 ? AppColors.kPrimaryColor : Colors.black), 3, context),
        ],
      ),
    );
  }

  SizedBox getIcon(Size size, Widget child, int index, BuildContext context) {
    return SizedBox(
      width: size.width * 0.25,
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
        return context.go("/");
      case 2:
        return context.go("/${CartView.route}");
      case 3:
        final authToken = Provider.of<AuthToken>(context, listen: false);
        if (authToken.loginToken == null) {
          return context.go('/${Auth.route}');
        } else {
          return context.go('/account/${AccountInformationView.route}');
        }

      default:
        break;
    }
  }
}
