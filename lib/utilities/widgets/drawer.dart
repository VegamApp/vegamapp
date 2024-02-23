
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/state_management/categories/categories_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/custom_expanded_tile.dart';
import 'package:m2/views/cms_view.dart';
import 'package:m2/views/product_views/product_view.dart';
import 'package:provider/provider.dart';

import '../../views/contact_view.dart';

// Build drawer side bar for mobile view
class DrawerContainer extends StatelessWidget {
  DrawerContainer({
    super.key,
    required this.size,
  });
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
                        Row(
                          children: [
                            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.primaryColor)),
                            Text('SHOP BY CATEGORY', style: AppStyles.getBoldTextStyle(fontSize: 18, color: AppColors.fadedText)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: categories.data['categories']['items'][0]['children'].length,
                          itemBuilder: (context, index) {
                            if (categories.data['categories']['items'][0]['children'][index]['include_in_menu'] == 0) {
                              return const SizedBox();
                            }
                            if (categories.data['categories']['items'][0]['children'][index]['children'] == null ||
                                categories.data['categories']['items'][0]['children'][index]['children'].isEmpty) {
                              var data = categories.data['categories']['items'][0]['children'][index];
                              return ListTile(
                                onTap: () {
                                  context.push('/${ProductView.route}?categoryUid=${data['uid']}&title=${data['name']}');
                                },
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                title: Text(
                                  data['name'],
                                  style: AppStyles.getMediumTextStyle(fontSize: 15),
                                ),
                              );
                            }
                            return CustomExpansionTile(
                              // initiallyExpanded: false,
                              // expandedAlignment: Alignment.centerRight,
                              // expandedCrossAxisAlignment: CrossAxisAlignment.end,
                              padding: const EdgeInsets.only(left: 10),
                              title: Text(
                                categories.data['categories']['items'][0]['children'][index]['name'],
                                style: AppStyles.getMediumTextStyle(fontSize: 15),
                              ),
                              expandedItem: _expanded,
                              key: ValueKey(index),
                              children: List.generate(
                                categories.data['categories']['items'][0]['children'][index]['children'].length,
                                (index3) {
                                  var data = categories.data['categories']['items'][0]['children'][index]['children'][index3];
                                  return TextButton(
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                    onPressed: () {
                                      context.push('/${ProductView.route}?categoryUid=${data['uid']}&title=${data['name']}');
                                      // navigate(context, ProductListingPage.route, arguments: {'catergoryId': data['id'], 'title': data['name']});
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Text(
                                          data['name'],
                                          style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Divider(color: AppColors.fadedText.withOpacity(0.2)),
                        const SizedBox(height: 10),
                        ListTile(
                          onTap: () {
                            context.push('/${CmsView.route}?id=about-us');
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          title: Text(
                            "About us",
                            style: AppStyles.getMediumTextStyle(fontSize: 15),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            context.push('/${CmsView.route}?id=customer-service');
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          title: Text(
                            "Customer Service",
                            style: AppStyles.getMediumTextStyle(fontSize: 15),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            context.push('/${CmsView.route}?id=privacy-policy-cookie-restriction-mode');
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          title: Text(
                            "Privacy and Cookie Policy",
                            style: AppStyles.getMediumTextStyle(fontSize: 15),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            context.pushNamed(ContactView.route);
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          title: Text(
                            "Contact Us",
                            style: AppStyles.getMediumTextStyle(fontSize: 15),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // Divider(color: AppColors.fadedText.withOpacity(0.2)),
                        // const SizedBox(height: 10),
                      ],
                    ),
        );
      },
    );
  }

  Widget getChild(Map data) {
    return const SizedBox();
  }

  ListTile getListTile(String title, void Function()? onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      title: Text(title, style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText)),
      onTap: onTap,
    );
  }
}
