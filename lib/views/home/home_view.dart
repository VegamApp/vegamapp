import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/models/product_model.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/home/home_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/footbar.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/product_views/product_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static String route = '/';
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ScrollController scrollController = ScrollController();
  HomeData homeData = HomeData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentContext = context;

    // Check if the widget is still mounted
    if (mounted) {
      var cartData = Provider.of<CartData>(currentContext, listen: false);
      var authToken = Provider.of<AuthToken>(currentContext, listen: false);

      homeData.getHomeData(currentContext).then((_) {
        // Check if the widget is still mounted before updating state
        if (mounted) {
          // Update state or trigger rebuild
          log('Mounted Here 1');
        }
      });

      cartData.getCartData(currentContext, authToken).then((_) {
        // Check if the widget is still mounted before updating state
        if (mounted) {
          log('Mounted Here 2');

          // Update state or trigger rebuild
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // var homeData = Provider.of<HomeData>(context);
    return BuildScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
        return Observer(builder: (context) {
          if (homeData.isLoading || homeData.data.isEmpty) {
            return BuildLoadingWidget(color: AppColors.primaryColor);
          }
          if (homeData.data.isEmpty) return const SizedBox();
          return ListView(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                controller: scrollController,
                // padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 1400 ? (constraints.maxWidth - 1400) / 2 : 60, vertical: 20),
                // itemCount: homeData.data['homepage']['blocks']['data'].length,
                // separatorBuilder: (context, index) => const SizedBox(height: 20),
                // itemBuilder: (context, index) => getWidgets(homeData.data['homepage']['blocks']['data'][index]),

                itemCount: homeData.data['homepage']!['blocks']!['data'].length,
                itemBuilder: (context, index) => getWidgets(
                    homeData.data['homepage']!['blocks']!['data'][index],
                    constraints),
              ),
              const SizedBox(height: 20),
              FootBar(
                  width: MediaQuery.sizeOf(context).width,
                  screenWidth: MediaQuery.sizeOf(context).width),
            ],
          );
        });
      }),
    );
  }

  getWidgets(Map<String, dynamic> data, BoxConstraints constraints) {
    print(data['desktop_status']);
    if (AppResponsive.isMobile(context) && !data['mobile_status']) {
      return const SizedBox();
    }
    if (!AppResponsive.isMobile(context) && !data['desktop_status']) {
      return const SizedBox();
    }
    switch (data['__typename']) {
      case 'ProductBlock':
        // if (data['display_style'] == 'slider') {
        return Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 1400
                      ? (constraints.maxWidth - 1400) / 2
                      : 0,
                  vertical: 20),
              child: ProductHorizontalListing(
                title: data['title'],
                id: data['id'].toString(),
                children: List<ProductItem>.generate(
                  data['products'].length,
                  (index) {
                    var productModel = Items.fromJson(data['products'][index]);
                    var price = productModel
                        .priceRange!.minimumPrice!.regularPrice!.value
                        .toString();
                    var originalPrice = productModel
                        .priceRange!.maximumPrice!.regularPrice!.value
                        .toString();
                    var offer = productModel
                        .priceRange!.maximumPrice!.discount!.percentOff
                        .toString();
                    return ProductItem(
                      productModel: productModel,
                      price: price,
                      priceSize: 14,
                      originalPrice: originalPrice,
                      offer: offer,
                      sku: productModel.sku!,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      // }
      //   return Column(
      //     children: [
      //       const SizedBox(height: 20),
      //       ProductGridWidget(
      //         title: data['name'],
      //         id: data['id'].toString(),
      //         children: List<ProductItem>.generate(
      //           data['products'].length,
      //           (index) {
      //             var productModel = Items.fromJson(data['products'][index]);
      //             var price = productModel.priceRange!.minimumPrice!.regularPrice!.value.toString();
      //             var originalPrice = productModel.priceRange!.maximumPrice!.regularPrice!.value.toString();
      //             var offer = productModel.priceRange!.maximumPrice!.discount!.percentOff.toString();
      //             return ProductItem(
      //               productModel: productModel,
      //               price: price,
      //               originalPrice: originalPrice,
      //               offer: offer,
      //               sku: productModel.sku!,
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   );
      case 'BannerBlock':
        return BannerBlock(
          title: data['show_title'] ? data['title'] : null,
          color: AppColors.buttonColor,
          backimage: List<Map<String, dynamic>>.from(data["banneritems"]),
          maintext: data["banner_template"] == "with_title"
              ? data["banneritems"][0]["title"]
              : null,
          data: data,
        );

      case 'SliderBlock':
        return SliderBlock(data: data);

      case 'CategoryBlock':
        return CategoryBlock(
          data: data,
          padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth > 1400
                  ? (constraints.maxWidth - 1400) / 2
                  : 20,
              vertical: 20),
        );

      case "ContentBlock":
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth > 1400
                  ? (constraints.maxWidth - 1400) / 2
                  : 20,
              vertical: 20),
          child: Column(
            children: [
              if (data['show_title'])
                TwoColoredTitle(
                    title: data['title'],
                    firstHeadColor: AppColors.primaryColor,
                    secondHeadColor: Colors.black),
              if (data['show_title']) const SizedBox(height: 10),
              Text(data['content'],
                  style: AppStyles.getRegularTextStyle(fontSize: 14)),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}

class CategoryBlock extends StatelessWidget {
  const CategoryBlock({super.key, required this.data, this.padding});
  final Map data;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (data['show_title'])
          TwoColoredTitle(
              title: data['title'],
              firstHeadColor: AppColors.primaryColor,
              secondHeadColor: Colors.black),
        if (data['show_title']) const SizedBox(height: 10),
        SizedBox(
          height: 300,
          child: ListView.separated(
            padding: padding,
            scrollDirection: Axis.horizontal,
            itemCount: data['category_info'].length,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                String path = '';
                if (data['category_info'][index]['category_id'] != null) {
                  path =
                      'categoryId=${data['category_info'][index]['category_id']}';
                }
                context.push('/${ProductView.route}?$path');
              },
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          data['category_info'][index]['image'] ??
                              "https://www.contentviewspro.com/wp-content/uploads/2017/07/default_image.png",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(data['category_info'][index]['name'],
                      style: AppStyles.getMediumTextStyle(fontSize: 14))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
