import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/models/product_model.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/product_views/product_view.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.productModel,
    required this.price,
    required this.originalPrice,
    required this.offer,
    this.priceSize,
    this.originalPriceSize,
    this.offerSize,
    required this.sku,
  });

  final Items productModel;
  final String price;
  final String? originalPrice;
  final double? offer;
  final double? priceSize;
  final double? originalPriceSize;
  final double? offerSize;
  final String sku;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () => context.go('/${ProductView.route}/${widget.productModel.urlKey}.${widget.productModel.urlSuffix}'),
      onHover: (value) => setState(() => _isHovered = value),
      child: Container(
        padding: const EdgeInsets.all(15),
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: AppColors.scaffoldColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: AppResponsive.isMobile(context)
              ? [BoxShadow(color: AppColors.evenFadedText, blurRadius: 5)]
              : !_isHovered
                  ? null
                  : [BoxShadow(color: AppColors.evenFadedText, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              // child: Center(
              // child: Container(
              // constraints: const BoxConstraints(minHeight: 100, maxHeight: 220),
              // color: Colors.amber,
              // height: 250,
              // child: CachedNetworkImage(imageUrl: widget.productModel.image!.url!),
              //   ),
              // ),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.green,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.productModel.image!.url!),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${widget.productModel.name}",
              style: AppStyles.getMediumTextStyle(fontSize: 16, color: AppColors.fadedText),
              maxLines: 2,
            ),
            const SizedBox(height: 5),
            FittedBox(
              child: BuildPriceWithOffer(
                price: widget.price,
                currency: currency,
                priceSize: widget.priceSize ?? 18,
                originalPrice: widget.originalPrice,
                originalPriceSize: widget.originalPriceSize ?? 16,
                offer: widget.offer,
                offerSize: widget.offerSize ?? 13,
              ),
            ),
            const SizedBox(height: 5),
            AppResponsive.isMobile(context)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BuildButtonSingle(
                        typeName: widget.productModel.sTypename!,
                        width: 400,
                        title: 'ADD TO CART',
                        buttonColor: AppColors.buttonColor,
                        textColor: Colors.white,
                        svg: 'assets/svg/shopping-cart.svg',
                        parentSku: widget.productModel.sku!,
                        selectedSku: widget.productModel.variants?[0].product?.sku!,
                        quantity: 1,
                      ),
                      // const SizedBox(height: 5),
                      // BuildButtonSingle(
                      //   typeName: widget.productModel.sTypename!,
                      //   width: 400,
                      //   title: 'BUY NOW',
                      //   buttonColor: AppColors.fontColor,
                      //   textColor: Colors.white,
                      //   svg: 'assets/svg/flash.svg',
                      //   parentSku: widget.productModel.sku!,
                      //   selectedSku:
                      //       widget.productModel.variants?[0].product?.sku!,
                      //   quantity: 1,
                      // ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: BuildButtonSingle(
                          typeName: widget.productModel.sTypename!,
                          width: 400,
                          title: 'ADD TO CART',
                          buttonColor: AppColors.buttonColor,
                          textColor: Colors.white,
                          svg: 'assets/svg/shopping-cart.svg',
                          parentSku: widget.productModel.sku!,
                          selectedSku: widget.productModel.variants?[0].product?.sku!,
                          quantity: 1,
                        ),
                      ),
                      // const SizedBox(width: 10),
                      // Expanded(
                      //   child: BuildButtonSingle(
                      //     typeName: widget.productModel.sTypename!,
                      //     width: 400,
                      //     title: 'BUY NOW',
                      //     buttonColor: AppColors.fontColor,
                      //     textColor: Colors.white,
                      //     svg: 'assets/svg/flash.svg',
                      //     parentSku: widget.productModel.sku!,
                      //     selectedSku: widget.productModel.variants?[0].product?.sku!,
                      //     quantity: 1,
                      //   ),
                      // ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
