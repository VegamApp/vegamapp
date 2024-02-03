import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/state_management/categories/categories_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/custom_expanded_tile.dart';
import 'package:m2/views/product_views/product_view.dart';
import 'package:provider/provider.dart';

// Build drawer side bar for mobile view
class DrawerContainer extends StatelessWidget {
  DrawerContainer({
    Key? key,
    required this.size,
  }) : super(key: key);
  final ValueNotifier<Key> _expanded = ValueNotifier(const ValueKey(0));

  final Size size;
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var categories = Provider.of<CategoriesData>(context);

    return Observer(
      builder: (context) {
        return Container(
          color: AppColors.scaffoldColor,
          width: size.width > 400 ? 400 : size.width,
          child: categories.isLoading
              ? const SizedBox.expand()
              : (categories.data.isEmpty || categories.data['categories']['items'].isEmpty)
                  ? Container(
                      margin: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(border: Border.all(width: 2, color: AppColors.evenFadedText), borderRadius: BorderRadius.circular(20)),
                      height: double.infinity,
                      child: Text('No items to show', style: AppStyles.getRegularTextStyle(fontSize: 16, color: AppColors.fadedText)))
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Text('SHOP BY CATEGORY', style: AppStyles.getBoldTextStyle(fontSize: 18, color: AppColors.fadedText)),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: categories.data['categories']['items'].length,
                          itemBuilder: (context, index) {
                            if (categories.data['categories']['items'][index]['children'] == null || categories.data['categories']['items'][index]['children'].isEmpty) {
                              return ListTile(
                                //TODO: Ontap
                                contentPadding: EdgeInsets.zero,
                                onTap: () {
                                  print(categories.data['categories']['items'][index]);
                                },
                                title: Text(
                                  categories.data['categories']['items'][index]['name'],
                                  style: AppStyles.getBoldTextStyle(fontSize: 16),
                                ),
                              );
                            }
                            return ExpansionTile(
                              initiallyExpanded: true,
                              maintainState: true,
                              // expandedAlignment: Alignment.centerRight,
                              // expandedCrossAxisAlignment: CrossAxisAlignment.end,
                              tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                              title: Text(
                                categories.data['categories']['items'][index]['name'],
                                style: AppStyles.getBoldTextStyle(fontSize: 16),
                              ),
                              children: List.generate(
                                categories.data['categories']['items'][index]['children'].length,
                                (index2) {
                                  if (categories.data['categories']['items'][index]['children'][index2]['include_in_menu'] == 0) {
                                    return const SizedBox();
                                  }
                                  if (categories.data['categories']['items'][index]['children'][index2]['children'] == null ||
                                      categories.data['categories']['items'][index]['children'][index2]['children'].isEmpty) {
                                    return ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                      onTap: () {
                                        var data = categories.data['categories']['items'][index]['children'][index2];
                                        context.goNamed(
                                          ProductView.route,
                                          queryParameters: {'categoryUid': data['uid']},
                                        );
                                      },
                                      title: Text(
                                        categories.data['categories']['items'][index]['children'][index2]['name'],
                                        style: AppStyles.getMediumTextStyle(fontSize: 14),
                                      ),
                                    );
                                  }
                                  return CustomExpansionTile(
                                      // initiallyExpanded: false,
                                      // expandedAlignment: Alignment.centerRight,
                                      // expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                      padding: const EdgeInsets.only(left: 10),
                                      title: Text(categories.data['categories']['items'][index]['children'][index2]['name']),
                                      expandedItem: _expanded,
                                      key: ValueKey(index2),
                                      children: List.generate(
                                        categories.data['categories']['items'][index]['children'][index2]['children'].length,
                                        (index3) {
                                          var data = categories.data['categories']['items'][index]['children'][index2]['children'][index3];
                                          return TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                            onPressed: () {
                                              print(data);
                                              context.goNamed(
                                                ProductView.route,
                                                queryParameters: {'categoryUid': data['uid']},
                                              );
                                            },
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: Text(
                                                  data['name'],
                                                  style: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.fadedText),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ));
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        // TextButton(
                        //   onPressed: () => navigate(context, CMSPage.route, arguments: {'id': 'our-story', 'title': 'Our Story'}),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text('Our Story', style: AppStyles.getBoldTextStyle(fontSize: 16, color: AppColors.fadedText)),
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // TextButton(
                        //   onPressed: () => navigate(context, CMSPage.route, arguments: {'id': 'about-us', 'title': 'About Us'}),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text('About Us', style: AppStyles.getBoldTextStyle(fontSize: 16, color: AppColors.fadedText)),
                        //   ),
                        // ),
                        // TextButton(
                        //   onPressed: () => navigate(context, ContactUs.route),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text('Contact Us', style: AppStyles.getBoldTextStyle(fontSize: 16, color: AppColors.fadedText)),
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // TextButton(
                        //   onPressed: () => navigate(context, FAQView.route),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text('FAQS', style: AppStyles.getBoldTextStyle(fontSize: 16, color: AppColors.fadedText)),
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // TextButton(
                        //   onPressed: () => navigate(context, CMSPage.route, arguments: {'id': 'terms-and-conditions', 'title': 'Terms of use'}),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text('Terms of use', style: AppStyles.getBoldTextStyle(fontSize: 16, color: AppColors.fadedText)),
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // TextButton(
                        //   onPressed: () =>
                        //       navigate(context, CMSPage.route, arguments: {'id': 'return-and-replacement-policies', 'title': 'Shipping and Returns'}),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text('Shipping and Returns', style: AppStyles.getBoldTextStyle(fontSize: 16, color: AppColors.fadedText)),
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // TextButton(
                        //   onPressed: () => navigate(context, CMSPage.route, arguments: {'id': 'privacypolicy', 'title': 'Privacy and Security'}),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text('Privacy and Security', style: AppStyles.getBoldTextStyle(fontSize: 16, color: AppColors.fadedText)),
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                      ],
                    ),
        );
      },
    );
  }

  ListTile getListTile(String title, void Function()? onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      title: Text(title, style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText)),
      onTap: onTap,
    );
  }
}
