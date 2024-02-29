import 'package:go_router/go_router.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:m2/views/home/home_view.dart';
import 'package:m2/views/product_views/product_view.dart';

// Build a bar within a product display page to show various navigators
class MiniAppBar extends StatelessWidget {
  const MiniAppBar({super.key, required this.screenWidth, required this.navigationChild, this.showActions = true});
  final double screenWidth;
  final List navigationChild;
  final bool showActions;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: screenWidth,
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.85,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: navigationChild.length,
              separatorBuilder: (context, index) => getSeperation(),
              itemBuilder: (context, index) => Row(
                children: [
                  if (index == 0)
                    InkWell(
                      onTap: () => context.go(HomeView.route),
                      child: Center(
                        // child: Text(
                        //   "Home",
                        //   style: getLightTextStyle(fontSize: 14),
                        // ),
                        child: Icon(Icons.home, color: AppColors.fadedText, size: 20),
                      ),
                    ),
                  if (index == 0) getSeperation(),
                  InkWell(
                    onTap: () {
                      if (index != navigationChild.length - 1) {
                        context.go(Uri(path: '/${ProductView.route}', queryParameters: {"categoryUid": navigationChild[index]['uid']}).toString());
                      }
                      //  navigate(context, ProductListing(categoryUID: navigationChild[index]['uid']));
                    },
                    child: Center(
                      child: Text(
                        navigationChild[index]['name'],
                        style: index == navigationChild.length - 1 ? AppStyles.getMediumTextStyle(fontSize: 14) : AppStyles.getLightTextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // if (showActions)
          //   SizedBox(
          //     width: screenWidth * 0.15 > 80 ? 80 : screenWidth * 0.15,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: [
          //         InkWell(
          //           onTap: () {},
          //           child: Icon(
          //             Icons.share_outlined,
          //             color: AppColors.fadedText,
          //             size: screenWidth * 0.04 > 17.5 ? 17.5 : screenWidth * 0.04,
          //           ),
          //         ),
          //         InkWell(
          //             onTap: () {},
          //             child: SvgPicture.asset(
          //               'assets/svg/compare.svg',
          //               width: screenWidth * 0.04 > 17 ? 17 : screenWidth * 0.04,
          //             ))
          //       ],
          //     ),
          //   )
        ],
      ),
    );
  }

  SizedBox getSeperation() {
    return SizedBox(
      width: 30,
      child: Center(
        child: Icon(
          Icons.navigate_next,
          color: AppColors.fadedText,
        ),
      ),
    );
  }
}
