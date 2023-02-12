import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/state_management/categories/categories_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/appbar_searchfield.dart';
import 'package:m2/utilities/widgets/custom_expanded_tile.dart';
import 'package:m2/utilities/widgets/delivery_hover.dart';
import 'package:provider/provider.dart';

class BuildAppBar extends StatelessWidget implements PreferredSize {
  const BuildAppBar({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.isDesktop(context) ? 70 : size.width * 0.05, vertical: 10),
      height: AppResponsive.isDesktop(context) ? 200 : 60,
      child: AppResponsive(
        desktop: Row(
          children: [
            getHomeButton(size),
            const SizedBox(width: 50),
            const DeliveryHoverWidget(),
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
    );
  }

  InkWell getHomeButton(Size size) {
    return InkWell(
      // onTap: () => onPressed(0),
      child: SizedBox(
        width: size.width * 0.2 > 100 ? 100 : size.width * 0.2,
        child: Image.asset(logoUrl),
      ),
    );
  }

  @override
  Widget get child => AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(200);
}

class AppbarCategories extends StatefulWidget {
  const AppbarCategories({super.key});

  @override
  State<AppbarCategories> createState() => _AppbarCategoriesState();
}

class _AppbarCategoriesState extends State<AppbarCategories> {
  List<bool> portalTargets = [];

  void populateTargets(CategoriesData categories) {
    portalTargets = List.generate(categories.data['categories']['items'][0]['children'].length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoriesData>(context);
    return Observer(builder: (context) {
      if (categories.data.isNotEmpty && categories.data['categories']['items'][0]['children'].isNotEmpty && portalTargets.isEmpty) {
        populateTargets(categories);
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          categories.data.isEmpty
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    categories.data['categories']['items'][0]['children'].length,
                    (index) {
                      if (categories.data['categories']['items'][0]['children'][index]['include_in_menu'] == 0) {
                        return const SizedBox();
                      }
                      return categories.data['categories']['items'][0]['children'][index]['children'] == null ||
                              categories.data['categories']['items'][0]['children'][index]['children'].isEmpty
                          ? InkWell(
                              onTap: () {},
                              child: Container(
                                height: 100,
                                constraints: const BoxConstraints(minWidth: 100),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                child: Text(
                                  categories.data['categories']['items'][0]['children'][index]['name'],
                                  style: AppStyles.getMediumTextStyle(fontSize: 14),
                                ),
                              ),
                            )
                          // : PopupMenuButton(
                          //     tooltip: '',
                          //     position: PopupMenuPosition.under,
                          //     child: Container(
                          //       height: 100,
                          //       padding: const EdgeInsets.symmetric(horizontal: 20),
                          //       alignment: Alignment.center,
                          //       child: Text(
                          //         categories.data['categories']['items'][0]['children'][index]['name'],
                          //         style: AppStyles.getMediumTextStyle(fontSize: 14),
                          //       ),
                          //     ),
                          //     itemBuilder: (context) {
                          //       return [
                          //         PopupMenuItem(
                          //           height: 300,
                          //           enabled: false,
                          //           // child: SizedBox(),
                          //           child: Container(
                          //             color: AppColors.scaffoldColor,
                          //             width: size.width,
                          //             constraints: BoxConstraints(maxWidth: size.width, maxHeight: 300),
                          //             child: Column(
                          //               crossAxisAlignment: CrossAxisAlignment.start,
                          //               children: List.generate(
                          //                 categories.data['categories']['items'][0]['children'][index]['children'].length,
                          //                 (index2) => ConstrainedBox(
                          //                   constraints: const BoxConstraints(maxWidth: 200),
                          //                   child: categories.data['categories']['items'][0]['children'][index]['children'][index2]['children'] ==
                          //                               null ||
                          //                           categories
                          //                               .data['categories']['items'][0]['children'][index]['children'][index2]['children'].isEmpty
                          //                       ? InkWell(
                          //                           onTap: () {},
                          //                           child: Padding(
                          //                             padding: const EdgeInsets.symmetric(vertical: 10),
                          //                             child: Text(
                          //                               categories.data['categories']['items'][0]['children'][index]['children'][index2]['name'],
                          //                               style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.fadedText),
                          //                             ),
                          //                           ),
                          //                         )
                          //                       : ExpansionTile(
                          //                           initiallyExpanded: true,
                          //                           title: Text(
                          //                             categories.data['categories']['items'][0]['children'][index]['children'][index2]['name'],
                          //                             style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.fadedText),
                          //                           ),
                          //                         ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         )
                          //       ];
                          //     },
                          //   );
                          : PortalTarget(
                              visible: portalTargets[index],
                              anchor: const Aligned(
                                follower: Alignment.topCenter,
                                target: Alignment.bottomCenter,
                                shiftToWithinBound: AxisFlag(x: true, y: true),
                              ),
                              // anchor: Filled(),
                              portalFollower: MouseRegion(
                                onEnter: (event) => setState(() => portalTargets[index] = true),
                                onExit: (event) => setState(() => portalTargets[index] = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  constraints: const BoxConstraints(maxWidth: 500),
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.scaffoldColor,
                                    boxShadow: [
                                      BoxShadow(color: AppColors.fadedText, blurRadius: 5),
                                    ],
                                  ),
                                  // height: 300,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(
                                      categories.data['categories']['items'][0]['children'][index]['children'].length,
                                      (index2) {
                                        if (categories.data['categories']['items'][0]['children'][index]['children'][index2]['include_in_menu'] ==
                                            "0") {
                                          return const SizedBox();
                                        }
                                        return ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 200),
                                          child: categories.data['categories']['items'][0]['children'][index]['children'][index2]['children'] ==
                                                      null ||
                                                  categories.data['categories']['items'][0]['children'][index]['children'][index2]['children'].isEmpty
                                              ? ListTile(
                                                  onTap: () {
                                                    print(categories.data['categories']['items'][0]['children'][index]['children'][index2]);
                                                  },
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                                  title: Text(
                                                    categories.data['categories']['items'][0]['children'][index]['children'][index2]['name'],
                                                    style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.fadedText),
                                                  ),
                                                )
                                              : ExpansionTile(
                                                  initiallyExpanded: true,
                                                  title: Text(
                                                    categories.data['categories']['items'][0]['children'][index]['children'][index2]['name'],
                                                    style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.fadedText),
                                                  ),
                                                ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              child: MouseRegion(
                                // style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20)),
                                // onPressed: () {
                                //   setState(() => portalTargets[index] = true);
                                //   print(portalTargets);
                                // },
                                onEnter: (event) {
                                  portalTargets = List.generate(portalTargets.length, (indexer) => false);
                                  setState(() => portalTargets[index] = true);
                                },
                                onExit: (event) {
                                  setState(() => portalTargets = List.generate(portalTargets.length, (index) => false));
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
                ),
          Divider(height: 2, color: AppColors.dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: const AppbarSearchService(),
              ),
            ],
          )
        ],
      );
    });
  }
}
