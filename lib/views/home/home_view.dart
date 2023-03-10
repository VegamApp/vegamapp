import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/models/product_model.dart';
import 'package:m2/services/state_management/home/home_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/loading_builder.dart';
import 'package:m2/utilities/widgets/scaffold_body.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static String route = '/';
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var homeData = Provider.of<HomeData>(context);
    return BuildScaffold(
      child: Observer(builder: (context) {
        if (homeData.isLoading) {
          return BuildLoadingWidget(color: AppColors.primaryColor);
        }
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          itemCount: homeData.data['homepage']['blocks']['data'].length,
          // separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) => getWidgets(homeData.data['homepage']['blocks']['data'][index]),
        );
      }),
    );
  }

  getWidgets(Map<String, dynamic> data) {
    if (AppResponsive.isMobile(context) && !data['mobile_status']) {
      return SizedBox();
    }
    if (!AppResponsive.isMobile(context) && !data['status']) {
      return SizedBox();
    }
    switch (data['__typename']) {
      case 'ProductBlock':
        if (data['display_style'] == 'slider') {
          return Column(
            children: [
              const SizedBox(height: 20),
              ProductHorizontalListing(
                title: data['name'],
                id: data['id'].toString(),
                children: List<ProductItem>.generate(
                  data['products'].length,
                  (index) {
                    var productModel = Items.fromJson(data['products'][index]);
                    var price = productModel.priceRange!.minimumPrice!.regularPrice!.value.toString();
                    var originalPrice = productModel.priceRange!.maximumPrice!.regularPrice!.value.toString();
                    var offer = productModel.priceRange!.maximumPrice!.discount!.percentOff.toString();
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
            ],
          );
        }
        return Column(
          children: [
            const SizedBox(height: 20),
            ProductGridWidget(
              title: data['name'],
              id: data['id'].toString(),
              children: List<ProductItem>.generate(
                data['products'].length,
                (index) {
                  var productModel = Items.fromJson(data['products'][index]);
                  var price = productModel.priceRange!.minimumPrice!.regularPrice!.value.toString();
                  var originalPrice = productModel.priceRange!.maximumPrice!.regularPrice!.value.toString();
                  var offer = productModel.priceRange!.maximumPrice!.discount!.percentOff.toString();
                  return ProductItem(
                    productModel: productModel,
                    price: price,
                    originalPrice: originalPrice,
                    offer: offer,
                    sku: productModel.sku!,
                  );
                },
              ),
            ),
          ],
        );
      case 'BannerBlock':
        return BannerBlock(data: data);

      case 'SliderBlock':
        return SliderBlock(data: data);

      case 'CategoryBlock':
        return CatergoryWidget(data: data);

      default:
        return SizedBox();
    }
  }
}
