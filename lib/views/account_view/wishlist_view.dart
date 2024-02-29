import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/customer_apis.dart';
import 'package:m2/services/api_services/product_apis.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/models/wishlist_model.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/services/state_management/wishlist/wishlist_dart.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/account_sidebar.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/account_view/account_information_view.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/product_views/product_view.dart';
import 'package:provider/provider.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});
  static String route = 'wishlist';
  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  late CartData cartData;
  late AuthToken authToken;
  late WishlistData wishlistData;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      wishlistData.getWishlistData(context);
      authToken.getUser(context, GraphQLProvider.of(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    cartData = Provider.of<CartData>(context);
    authToken = Provider.of<AuthToken>(context);
    wishlistData = Provider.of<WishlistData>(context);

    return BuildScaffold(
      currentIndex: -1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: () => wishlistData.getWishlistData(context),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.isMobile(context)
                    ? 20
                    : constraints.maxWidth > 1400
                        ? (constraints.maxWidth - 1400) / 2
                        : 60,
                vertical: 20,
              ),
              child: AppResponsive(
                desktop: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: AccountSideBar(currentPage: AccountInformationView.route),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                          margin: const EdgeInsets.only(top: 40),
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldColor,
                            boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 50, offset: const Offset(0, 10))],
                          ),
                          child: getBody(context, size)),
                    ),
                  ],
                ),
                mobile: getBody(context, size),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getBody(BuildContext context, Size size) {
    return Observer(
      name: 'Wishlist',
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('Wishlist', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.primaryColor)),
            ),
            const SizedBox(height: 20),
            // wishlistData.isLoading || authToken.isLoading
            //     ? BuildLoadingWidget(color: AppColors.primaryColor)
            //     : wishlistData.hasExceptions
            //         ? BuildErrorWidget(errorMsg: wishlistData.errorMsg)
            //         : authToken.loginToken == null || wishlistData.wishlist!.items!.isEmpty
            //             ? Center(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(20.0),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       // LottieBuilder.asset('assets/animations/heart.json'),
            //                       const Icon(Icons.favorite_outline, size: 100),
            //                       // SizedBox(height: 300, width: 300, child: Image.asset('assets/images/20-love-heart-outline.gif')),
            //                       const SizedBox(height: 20),
            //                       if (authToken.loginToken == null) ...[
            //                         Text('Login to add items to wishlist.', style: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.fadedText)),
            //                         const SizedBox(height: 10),
            //                         TextButton(
            //                           style: TextButton.styleFrom(
            //                             backgroundColor: AppColors.primaryColor,
            //                             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            //                           ),
            //                           onPressed: () => context.pushNamed(Auth.route),
            //                           child: Text('LOGIN', style: AppStyles.getRegularTextStyle(fontSize: 16, color: Colors.white)),
            //                         )
            //                       ] else
            //                         Text('Your wishlist is empty.', style: AppStyles.getRegularTextStyle(fontSize: 16, color: AppColors.fadedText)),
            //                     ],
            //                   ),
            //                 ),
            //               )
            //             : ListView.separated(
            //                 shrinkWrap: true,
            //                 physics: const NeverScrollableScrollPhysics(),
            //                 itemCount: wishlistData.wishlist!.items!.length,
            //                 separatorBuilder: (context, index) => Padding(
            //                   padding: const EdgeInsets.symmetric(vertical: 5),
            //                   child: Divider(thickness: 1, color: AppColors.dividerColor),
            //                 ),
            //                 itemBuilder: (context, index) => BuildWishlistItem(
            //                   wishlistId: authToken.user.wishlists![0].id!,
            //                   data: wishlistData.wishlist!.items![index],
            //                   refetch: () => wishlistData.getWishlistData(context),
            //                   authToken: authToken,
            //                 ),
            //               ),
            Query(
              options: QueryOptions(document: gql(CustomerApis.wishList)),
              builder: (result, {fetchMore, refetch}) {
                authToken.getUser(context, GraphQLProvider.of(context));
                if (result.isLoading) {
                  return BuildLoadingWidget(color: AppColors.primaryColor);
                }
                try {
                  authToken.putWishlistCount(result.data!['wishlist']['items_count']);
                } catch (e) {
                  //print(e);
                }
                if (authToken.loginToken == null || result.data == null || result.data!['wishlist']['items'].isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // LottieBuilder.asset('assets/animations/heart.json'),
                          const Icon(Icons.favorite_outline, size: 100),
                          // SizedBox(height: 300, width: 300, child: Image.asset('assets/images/20-love-heart-outline.gif')),
                          const SizedBox(height: 20),
                          if (authToken.loginToken == null) ...[
                            Text('Login to add items to wishlist.', style: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.fadedText)),
                            const SizedBox(height: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              ),
                              onPressed: () => context.pushNamed(Auth.route),
                              child: Text('LOGIN', style: AppStyles.getRegularTextStyle(fontSize: 16, color: Colors.white)),
                            )
                          ] else
                            Text('Your wishlist is empty.', style: AppStyles.getRegularTextStyle(fontSize: 16, color: AppColors.fadedText)),
                        ],
                      ),
                    ),
                  );
                }
                if (result.hasException || authToken.user.wishlists == null) {
                  return Center(
                    child: BuildErrorWidget(onRefresh: refetch),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: result.data!['wishlist']['items'].length,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(thickness: 1, color: AppColors.dividerColor),
                  ),
                  itemBuilder: (context, index) => BuildWishlistItem(
                    wishlistId: authToken.user.wishlists![0].id!,
                    data: result.data!['wishlist']['items'][index],
                    refetch: refetch,
                    authToken: authToken,
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}

class BuildWishlistItem extends StatefulWidget {
  const BuildWishlistItem({super.key, required this.data, this.refetch, required this.wishlistId, required this.authToken});
  final Map<String, dynamic> data;
  final VoidCallback? refetch;
  final String wishlistId;
  final AuthToken authToken;
  @override
  State<BuildWishlistItem> createState() => _BuildWishlistItemState();
}

class _BuildWishlistItemState extends State<BuildWishlistItem> {
  late List<String?> varientData = List.generate(widget.data['product']['configurable_options'].length, (index) => null);
  late String selectedSku = widget.data['product']['sku'];

  @override
  Widget build(BuildContext context) {
    CartData cartData = Provider.of<CartData>(context);
    return InkWell(
      onTap: () => context.push('/${ProductView.route}/${widget.data['product']['url_key']}'),
      // onTap: () {
      // log(jsonEncode(widget.data));
      //   context.push('/product/${widget.data['product']['url_key']}');
      // },
      child: Row(
        children: [
          Expanded(
            flex: 30,
            child: Container(
              constraints: const BoxConstraints(minHeight: 200, minWidth: 100),
              decoration: BoxDecoration(
                // color: Colors.amber,
                border: Border.all(width: 1, color: AppColors.buttonColor),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.data['product']['image']['url']),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(widget.data['product']['name'], style: AppStyles.getMediumTextStyle(fontSize: 16))),
                    const SizedBox(width: 5),
                    Mutation(
                        options: MutationOptions(
                          document: gql(ProductApi.removeProductsFromWishlist),
                          onCompleted: (result) {
                            //print(result);
                            // //print('complete ${result!['addProductsToCart']['cart']['total_quantity']}');
                            if (result != null) {
                              try {
                                showSnackBar(context: context, message: result['removeProductsFromWishlist']['user_errors'][0]['message'], backgroundColor: Colors.red);
                              } catch (e) {
                                showSnackBar(
                                  context: context,
                                  message: "Removed from shopping list",
                                  backgroundColor: AppColors.snackbarSuccessBackgroundColor,
                                );
                              }
                              widget.refetch!();
                            }
                          },
                          onError: (result) {
                            //print('error $result');
                          },
                        ),
                        builder: (RunMutation runMutation, QueryResult? result) {
                          return IconButton(
                            onPressed: () {
                              runMutation({
                                'wishlistId': widget.authToken.user.wishlists![0].id,
                                'wishlistItemsIds': [widget.data['id']]
                              });
                            },
                            icon: const Icon(Icons.delete_outline, color: Colors.black),
                          );
                        }),
                  ],
                ),
                if (widget.data['product']['configurable_options'] != null)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      widget.data['product']['configurable_options'].length,
                      (index) {
                        var data = widget.data['product']['configurable_options'][index];
                        // if (widget.data['configurable_options'][index]['attribute_code'] == 'color') {
                        //   return getColorVarient(widget.data['configurable_options'][index], index);
                        // }
                        // return getTextVarient(widget.data['configurable_options'][index], index);
                        return ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: ButtonTheme(
                            layoutBehavior: ButtonBarLayoutBehavior.constrained,
                            alignedDropdown: true,
                            height: 15,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: varientData[index],
                              hint: Text(data['label']),
                              onChanged: (value) {
                                varientData[index] = value;
                                setSku();
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.buttonColor, width: 1)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.buttonColor, width: 1)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: AppColors.buttonColor, width: 1)),
                              ),
                              items: List.generate(
                                data['values'].length,
                                (configIndex) => DropdownMenuItem(
                                  value: data['values'][configIndex]['uid'],
                                  child: Text(data['values'][configIndex]['label'], style: AppStyles.getRegularTextStyle(fontSize: 12)),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            if (widget.data['product']['special_price'] != null)
                              TextSpan(
                                text: '$currency ${widget.data['product']['special_price'].toStringAsFixed(2)}\n',
                                style: AppStyles.getMediumTextStyle(fontSize: 16, color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: '$currency ${widget.data['product']['price_range']['minimum_price']['regular_price']['value'].toStringAsFixed(2)}',
                                    style: AppStyles.getRegularTextStyle(fontSize: 12, color: Colors.black).copyWith(decoration: TextDecoration.lineThrough),
                                  ),
                                  TextSpan(
                                    text: ' ${widget.data['product']['price_range']['maximum_price']['discount']['percent_off']}% off',
                                    style: AppStyles.getRegularTextStyle(fontSize: 12, color: Colors.black),
                                  ),
                                ],
                              )
                            else
                              TextSpan(
                                text: '$currency ${widget.data['product']['price_range']['minimum_price']['regular_price']['value'].toStringAsFixed(2)}',
                                style: AppStyles.getMediumTextStyle(fontSize: 16, color: Colors.black),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Center(
                      child: Mutation(
                          options: MutationOptions(
                            document: gql(widget.data['product']['__typename'] == 'SimpleProduct' ? ProductApi.addWishlistItemstoCart : ProductApi.addProductToCart),
                            onCompleted: (result) {
                              //print(result);
                              try {
                                if (result!['addWishlistItemsToCart']['status']) {
                                  showSnackBar(context: context, message: "Added to cart", backgroundColor: AppColors.snackbarSuccessBackgroundColor);
                                } else {
                                  showSnackBar(
                                      context: context,
                                      message: result['addWishlistItemsToCart']['add_wishlist_items_to_cart_user_errors'][0]['message'],
                                      backgroundColor: AppColors.snackbarSuccessBackgroundColor);
                                }
                              } catch (e) {
                                try {
                                  showSnackBar(
                                    context: context,
                                    message: result!['addProductsToCart']['user_errors'][0]['message'],
                                    backgroundColor: AppColors.primaryColor,
                                  );
                                } catch (e) {
                                  cartData.putCartCount(result!['addProductsToCart']['cart']['total_quantity']);
                                  cartData.putCartPrice(result['addProductsToCart']['cart']['prices']['grand_total']['value'].toDouble());
                                  showSnackBar(context: context, message: "Added to cart", backgroundColor: AppColors.snackbarSuccessBackgroundColor);
                                  // await Future.delayed(const Duration(milliseconds: 300), () async {
                                  //   await cartData.getCartData(context, authToken);
                                  // });
                                  setState(() {});

                                  //print(e);
                                }
                              }
                              widget.refetch!();
                              cartData.getCartData(context, Provider.of<AuthToken>(context, listen: false));
                              //print('complete ${result!['addProductsToCart']['cart']['total_quantity']}');
                            },
                            onError: (result) {
                              //print('error $result');
                            },
                          ),
                          builder: (RunMutation runMutation, QueryResult? result) {
                            return TextButton(
                              style: AppStyles.filledButtonStyle,
                              onPressed: () {
                                String sku;
                                if (widget.data['product']['__typename'] == 'SimpleProduct') {
                                  sku = widget.data['product']['sku'];
                                  runMutation({
                                    'wishlistId': widget.wishlistId,
                                    'wishlistItemsIds': [widget.data['id']]
                                  });
                                } else {
                                  if (varientData.contains(null)) {
                                    showSnackBar(context: context, message: "Select a varient", backgroundColor: Colors.red);
                                    return;
                                  }
                                  sku = selectedSku;
                                  runMutation({
                                    'cartIdString': cartData.cartId,
                                    'cartItemsMap': [
                                      {'quantity': 1, 'sku': sku}
                                    ]
                                  });
                                }
                              },
                              child: result!.isLoading ? const BuildLoadingWidget() : Text("Add to Cart", style: AppStyles.getRegularTextStyle(fontSize: 14)),
                            );
                          }),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  setSku() {
    if (varientData.contains(null)) return;

    List<Map<String, dynamic>> varients = List<Map<String, dynamic>>.from(widget.data['product']['variants']);
    // print(varients);
    varients.forEach((element) {
      for (int i = 0; i < varientData.length; i++) {
        if (!varientData.contains(element['attributes'][i]['uid'])) return;
      }

      selectedSku = element['product']['sku'];
      widget.data['product']['media_gallery'] = element['product']['media_gallery'] != null && element['product']['media_gallery'].isNotEmpty
          ? element['product']['media_gallery']
          : widget.data['product']['media_gallery'];
      widget.data['product']['special_price'] = element['product']['special_price'];
      widget.data['product']['price_range'] = element['product']['price_range'];
      setState(() {});
    });
  }
}
