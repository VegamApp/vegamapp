import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/models/product_model.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({super.key, required this.data, this.refetch});
  final Map<String, dynamic> data;
  final VoidCallback? refetch;
  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  // generate product model from the get api
  late ProductModel productModel;

  // show price
  String price = '';

  // show original price. If special price is available, this price is crossed off
  String? originalPrice;
  // if not null show %
  double? offer;

  // for initial media gallery
  List<Map<String, dynamic>> originalMedia = [];

  // if configurable, show media gallery of selected product
  List<Map<String, dynamic>> mediaGallery = [];
  @override
  void initState() {
    // Initialize product model
    productModel = ProductModel.fromJson(widget.data['products']);

    originalMedia = List<Map<String, dynamic>>.from(widget.data['products']['items'][0]['media_gallery']);
    mediaGallery = originalMedia;
    if (productModel.items![0].variants != null && productModel.items![0].variants!.isNotEmpty) {
      mediaGallery = productModel.items![0].variants![0].product!.mediaGallery!;
    }

    price = productModel.items![0].specialPrice ?? productModel.items![0].priceRange!.minimumPrice!.regularPrice!.value.toString();
    originalPrice = productModel.items![0].priceRange!.maximumPrice!.regularPrice!.value.toString();
    offer = productModel.items![0].priceRange!.maximumPrice!.discount!.percentOff;
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
        // Show mini app bar with categories
        MiniAppBar(screenWidth: size.width, navigationChild: widget.data['products']['items'][0]['categories']),
        const SizedBox(height: 10),
        // Show media widget
        ProductMediaContainer(width: size.width, data: mediaGallery),
        const SizedBox(height: 30),
        // Name
        Text(
          "${productModel.items?[0].name}",
          style: AppStyles.getMediumTextStyle(fontSize: 22, color: AppColors.fontColor),
        ),
        const SizedBox(height: 10),
        // show rating
        BuildRating(
          rating: productModel.items?[0].ratingSummary,
          noOfReviews: productModel.items?[0].reviewCount,
        ),
        // Show price
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
        // Show varients if any
        ProductVarientWidget(
          productModel: productModel,
          onUpdated: (newMedia) {
            if (newMedia != null) {
              setState(() => mediaGallery = newMedia);
              ProductMediaContainerState.refreshCurrentDisplayWidget(newMedia[0]['url']);
            }
          },
        ),
        const SizedBox(height: 30),
        // Description widget
        BuildDescriptionReview(width: size.width, description: productModel.items![0].description!.html!, sku: productModel.items![0].sku!),
        const SizedBox(height: 20),
        // show related products if any
        if (productModel.items![0].relatedProducts != null && productModel.items![0].relatedProducts!.isNotEmpty)
          TwoColoredTitle(title: 'Related Products', firstHeadColor: AppColors.primaryColor, secondHeadColor: AppColors.fontColor),
        if (productModel.items![0].relatedProducts != null)
          LayoutBuilder(builder: (context, constraints) {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: productModel.items![0].relatedProducts!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: constraints.maxWidth < 500 ? 200 : 400,
                // crossAxisCount: constraints.maxWidth < 600 ? 2 : (constraints.maxWidth / 250).floor(),
                crossAxisSpacing: constraints.maxWidth < 500 ? 10 : 30,
                mainAxisSpacing: constraints.maxWidth < 500 ? 10 : 30,
                mainAxisExtent: 400,
              ),
              itemBuilder: (context, index) {
                var price = productModel.items![0].relatedProducts![index].specialPrice ??
                    productModel.items![0].relatedProducts![index].priceRange!.minimumPrice!.regularPrice!.value.toString();
                var originalPrice = productModel.items![0].relatedProducts![index].priceRange!.maximumPrice!.regularPrice!.value.toString();
                var offer = productModel.items![0].relatedProducts![index].priceRange!.maximumPrice!.discount!.percentOff;
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

  Widget getDesktopChildren(Size size) {
    return LayoutBuilder(builder: (context, constraints) {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 1400 ? (constraints.maxWidth - 1400) / 2 : 20, vertical: 20),
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
                  data: mediaGallery,
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
                      ProductVarientWidget(
                        productModel: productModel,
                        onUpdated: (newMedia) {
                          if (newMedia != null) {
                            setState(() => mediaGallery = newMedia);
                            ProductMediaContainerState.refreshCurrentDisplayWidget(newMedia[0]['url']);
                          }
                        },
                      ),
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
            TwoColoredTitle(title: 'Related Products', firstHeadColor: AppColors.primaryColor, secondHeadColor: AppColors.fontColor),
          if (productModel.items![0].relatedProducts != null)
            LayoutBuilder(builder: (context, constraints) {
              return GridView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: productModel.items![0].relatedProducts!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: constraints.maxWidth < 500 ? 200 : 400,
                  // crossAxisCount: constraints.maxWidth < 600 ? 2 : (constraints.maxWidth / 250).floor(),
                  crossAxisSpacing: constraints.maxWidth < 500 ? 10 : 30,
                  mainAxisSpacing: constraints.maxWidth < 500 ? 10 : 30,
                  mainAxisExtent: 400,
                ),
                itemBuilder: (context, index) {
                  var price = productModel.items![0].relatedProducts![index].specialPrice ??
                      productModel.items![0].relatedProducts![index].priceRange!.minimumPrice!.regularPrice!.value.toString();
                  var originalPrice = productModel.items![0].relatedProducts![index].priceRange!.maximumPrice!.regularPrice!.value.toString();
                  var offer = productModel.items![0].relatedProducts![index].priceRange!.maximumPrice!.discount!.percentOff;
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
    });
  }
}
