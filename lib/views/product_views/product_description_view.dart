import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/models/product_model.dart';
import 'package:m2/services/sliver_grid_with_fixed_height.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/description_and_review.dart';
import 'package:m2/utilities/widgets/widgets.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({super.key, required this.data, this.refetch});
  final Map<String, dynamic> data;
  final VoidCallback? refetch;
  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  late ProductModel productModel;
  String price = '';
  String? originalPrice;
  String? offer;

  @override
  void initState() {
    productModel = ProductModel.fromJson(widget.data['products']);
    print(productModel.toString());
    price = productModel.items![0].priceRange!.minimumPrice!.regularPrice!.value.toString();
    originalPrice = productModel.items![0].priceRange!.maximumPrice!.regularPrice!.value.toString();
    offer = productModel.items![0].priceRange!.maximumPrice!.discount!.percentOff.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppResponsive(mobile: getMobileChildren(size), desktop: getDesktopChildren(size));
  }

  Widget getMobileChildren(Size size) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        MiniAppBar(screenWidth: size.width, navigationChild: widget.data['products']['items'][0]['categories']),
        const SizedBox(height: 10),
        ProductMediaContainer(width: size.width, data: List<Map<String, dynamic>>.from(widget.data['products']['items'][0]['media_gallery'])),
        const SizedBox(height: 30),
        Text(
          "${productModel.items?[0].name}",
          style: AppStyles.getMediumTextStyle(fontSize: 22, color: AppColors.fontColor),
        ),
        const SizedBox(height: 10),
        BuildRating(
          rating: productModel.items?[0].ratingSummary,
          noOfReviews: productModel.items?[0].reviewCount,
        ),
        // const SizedBox(height: 30),
        BuildPriceWithOffer(
          price: price,
          currency: currency,
          priceSize: 22,
          originalPrice: originalPrice,
          originalPriceSize: 18,
          offer: offer,
          offerSize: 13,
        ),
        const SizedBox(height: 30),
        Divider(height: 1, color: AppColors.dividerColor),
        const SizedBox(height: 20),
        ProductVarientWidget(productModel: productModel),
        const SizedBox(height: 30),
        BuildDescriptionReview(width: size.width, description: productModel.items![0].description!.html!, sku: productModel.items![0].sku!),
      ],
    );
  }

  Widget getDesktopChildren(Size size) {
    print(productModel.items![0].relatedProducts!.length);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.isMobile(context) ? 20 : 60, vertical: 20),
      children: [
        Row(children: [
          const Expanded(flex: 1, child: SizedBox()),
          const SizedBox(width: 50),
          Expanded(
            flex: 1,
            child: LayoutBuilder(builder: (context, constraints) {
              return MiniAppBar(screenWidth: constraints.maxWidth, navigationChild: widget.data['products']['items'][0]['categories']);
            }),
          ),
        ]),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProductMediaContainer(
                width: size.width,
                data: List<Map<String, dynamic>>.from(widget.data['products']['items'][0]['media_gallery']),
              ),
            ),
            const SizedBox(width: 50),
            Expanded(
              // flex: 5,
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(height: 1, color: AppColors.dividerColor),
                    const SizedBox(height: 30),
                    Text(
                      "${productModel.items?[0].name}",
                      style: AppStyles.getMediumTextStyle(fontSize: 22, color: AppColors.fontColor),
                    ),
                    const SizedBox(height: 10),
                    BuildRating(
                      rating: productModel.items?[0].ratingSummary,
                      noOfReviews: productModel.items?[0].reviewCount,
                    ),
                    const SizedBox(height: 10),
                    BuildPriceWithOffer(
                      price: price,
                      currency: currency,
                      priceSize: 22,
                      originalPrice: originalPrice,
                      originalPriceSize: 18,
                      offer: offer,
                      offerSize: 13,
                    ),
                    const SizedBox(height: 20),
                    Divider(height: 1, color: AppColors.dividerColor),
                    const SizedBox(height: 20),
                    ProductVarientWidget(productModel: productModel),
                  ],
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 30),
        BuildDescriptionReview(width: size.width, description: productModel.items![0].description!.html!, sku: productModel.items![0].sku!),
        const SizedBox(height: 20),
        if (productModel.items![0].relatedProducts != null && productModel.items![0].relatedProducts!.isNotEmpty)
          TwoColoredTitle(firstHead: 'Related', secondHead: "Products", firstHeadColor: AppColors.primaryColor, secondHeadColor: AppColors.fontColor),
        if (productModel.items![0].relatedProducts != null)
          LayoutBuilder(builder: (context, constraints) {
            return GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: productModel.items![0].relatedProducts!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: (constraints.maxWidth / 250).floor(),
                crossAxisSpacing: 40,
                mainAxisSpacing: 40,
                height: 400.0,
              ),
              itemBuilder: (context, index) {
                var price = productModel.items![0].relatedProducts![index].priceRange!.minimumPrice!.regularPrice!.value.toString();
                var originalPrice = productModel.items![0].relatedProducts![index].priceRange!.maximumPrice!.regularPrice!.value.toString();
                var offer = productModel.items![0].relatedProducts![index].priceRange!.maximumPrice!.discount!.percentOff.toString();
                return ProductItem(
                  productModel: productModel.items![0].relatedProducts![index],
                  price: price,
                  originalPrice: originalPrice,
                  offer: offer,
                  sku: productModel.items![0].relatedProducts![index].sku!,
                );
              },
            );
          }),
      ],
    );
  }
}
