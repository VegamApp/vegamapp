import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/state_management/categories/categories_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/appbar_searchfield.dart';
import 'package:m2/utilities/widgets/delivery_hover.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BuildAppBar extends StatelessWidget implements PreferredSize {
  BuildAppBar({super.key, required this.scaffoldKey, this.height});
  final GlobalKey<ScaffoldState> scaffoldKey;
  double? height;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!AppResponsive.isDesktop(context)) height = 60;
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
      ),
    );
  }

  InkWell getHomeButton(Size size) {
    return InkWell(
      // onTap: () => onPressed(0),
      child: SizedBox(
        width: size.width * 0.2 > 100 ? 100 : size.width * 0.2,
        height: size.width * 0.2 > 100 ? 100 : size.width * 0.2,
        child: Align(alignment: Alignment.centerLeft, child: Image.asset(logoUrl)),
      ),
    );
  }

  @override
  Widget get child => AppBar();

  @override
  Size get preferredSize => Size.fromHeight(height ?? 170);
}

class AppbarCategories extends StatefulWidget {
  const AppbarCategories({super.key});

  @override
  State<AppbarCategories> createState() => _AppbarCategoriesState();
}

class _AppbarCategoriesState extends State<AppbarCategories> {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoriesData>(context);
    return Observer(builder: (context) {
      if (categories.data.isNotEmpty && categories.data['categories']['items'][0]['children'].isNotEmpty && categories.portalTargets.isEmpty) {
        categories.populateTargets();
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                                height: 50,
                                constraints: const BoxConstraints(minWidth: 100),
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
                                onEnter: (event) => setState(() => categories.portalTargets[index] = true),
                                onExit: (event) => setState(() => categories.portalTargets[index] = false),
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
                                onEnter: (event) {
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
                ),
          Divider(height: 2, color: AppColors.dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
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
