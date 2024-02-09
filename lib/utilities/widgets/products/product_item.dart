import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/product_apis.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/models/product_model.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/services/state_management/user/user_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/product_views/product_view.dart';
import 'package:provider/provider.dart';

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
  bool isWishlistLoading = false;
  late AuthToken authToken;
  late CartData cartData;
  late UserData userData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cartData = Provider.of<CartData>(context);
    authToken = Provider.of<AuthToken>(context);
    userData = Provider.of<UserData>(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () => context.push('/${ProductView.route}/${widget.productModel.urlKey}.${widget.productModel.urlSuffix}'),
      // onTap: () => context.pushNamed(ProductView.route, pathParameters: {'url': '${widget.productModel.urlKey}.${widget.productModel.urlSuffix}'}),
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
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.productModel.image!.url!),
                  ),
                ),
                alignment: Alignment.topRight,
                child: Mutation(
                    options: MutationOptions(
                      document: gql(
                        widget.productModel.wishlistItem != null ? ProductApi.removeProductsFromWishlist : ProductApi.addToWishList,
                      ),
                      onError: (data) {
                        try {
                          showSnackBar(context: context, message: data!.graphqlErrors[0].message, backgroundColor: AppColors.snackbarErrorBackgroundColor);
                        } catch (e) {}
                      },
                      onCompleted: (data) {
                        print(data);
                        isWishlistLoading = true;
                        setState(() {});
                        if (data != null) {
                          try {
                            showSnackBar(
                              context: context,
                              message: widget.productModel.wishlistItem != null
                                  ? data['removeProductsFromWishlist']['user_errors'][0]['message']
                                  : data['addProductsToWishlist']['user_errors'][0]['message'],
                              backgroundColor: Colors.red,
                            );
                          } catch (e) {
                            showSnackBar(
                              context: context,
                              message: data['removeProductsFromWishlist'] != null ? "Removed from wishlist" : "Added to wishlist",
                              backgroundColor: AppColors.snackbarSuccessBackgroundColor,
                            );
                            if (widget.productModel.wishlistItem == null) {
                              getProductWishListData(context);
                            } else {
                              widget.productModel.wishlistItem = null;
                              isWishlistLoading = false;
                              setState(() {});
                            }
                          }
                          try {
                            if (widget.productModel.wishlistItem != null) {
                              authToken.putWishlistCount(data['removeProductsFromWishlist']['wishlist']['items_count']);
                            } else {
                              authToken.putWishlistCount(data['addProductsToWishlist']['wishlist']['items_count']);
                            }
                          } catch (e) {}
                        }
                      },
                    ),
                    builder: (RunMutation runMutation, QueryResult? mResult) {
                      return InkWell(
                        onTap: () {
                          if (userData.data.wishlists?[0].id != null) {
                            Map<String, dynamic> variables = {};

                            if (widget.productModel.wishlistItem != null) {
                              variables = {
                                'wishlistId': userData.data.wishlists?[0].id,
                                'wishlistItemsIds': [widget.productModel.wishlistItem]
                              };
                              // runMutation(variables);
                            } else {
                              variables = {
                                'id': userData.data.wishlists?[0].id,
                                'wishlistItems': [
                                  {'sku': widget.sku, 'quantity': 1}
                                ]
                              };
                            }

                            runMutation(variables);
                          } else {
                            showSnackBar(
                              context: context,
                              message: "You must login to add items to wishlist",
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                        child: mResult!.isLoading
                            ? BuildLoadingWidget(color: AppColors.primaryColor)
                            : Icon(
                                widget.productModel.wishlistItem != null ? Icons.favorite : Icons.favorite_outline,
                                color: widget.productModel.wishlistItem != null ? Colors.red : AppColors.fadedText,
                              ),
                      );
                    }),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${widget.productModel.name}",
              style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.fadedText),
              maxLines: 2,
            ),
            const SizedBox(height: 5),
            FittedBox(
              child: BuildPriceWithOffer(
                price: widget.price,
                currency: currency,
                priceSize: widget.priceSize ?? 16,
                originalPrice: widget.originalPrice,
                originalPriceSize: widget.originalPriceSize ?? 14,
                offer: widget.offer,
                offerSize: widget.offerSize ?? 12,
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

  getProductWishListData(context) async {
    var gqlClient = GraphQLProvider.of(context);
    QueryResult? result = await gqlClient.value.query(
      WatchQueryOptions(
        document: gql(r'''
      query products($filter: ProductAttributeFilterInput!){
        products(filter: $filter) {
          items {
            wishlistData{
              wishlistItem
            }
          }
        }
      }'''),
        variables: {
          'filter': {
            "sku": {'eq': widget.sku}
          }
        },
      ),
    );

    widget.productModel.wishlistItem = result.data!['products']['items'][0]['wishlistData'];
    isWishlistLoading = false;
    setState(() {});
  }
}
