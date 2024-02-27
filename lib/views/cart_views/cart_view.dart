import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:m2/services/api_services/cart_apis.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/search_services.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/cart_views/cart_addresss_view.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});
  static String route = 'cart';
  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  // To show numbers in a formated view
  var f = NumberFormat("#,##,##,##0.00", "en_IN");

  ScrollController scrollController = ScrollController();

  // Package imported
  final deboucer = Debouncer(milliseconds: 500);

  late CartData cartData;
  late AuthToken token;

  getCart() async {
    cartData = Provider.of<CartData>(context);
    token = Provider.of<AuthToken>(context);
    cartData.getCartData(context, token);
    // print(cartData.cartId);
    // print(token.loginToken);
  }

  @override
  void initState() {
    super.initState();
  }

  // Refetch cart or get a new cart on cart exception
  functionOnException(Function()? refetch) async {
    await cartData.getCartData(context, token);
    refetch!();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCart();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    cartData = Provider.of<CartData>(context);
    token = Provider.of<AuthToken>(context);
    return BuildScaffold(
      currentIndex: 2,
      child: LayoutBuilder(builder: (context, constraints) {
        return Query(
            options: QueryOptions(document: CartApis.cart, variables: {'id': cartData.cartId}),
            builder: (result, {fetchMore, refetch}) {
              if (result.isLoading) {
                return const BuildLoadingWidget();
              }
              if (result.hasException) {
                cartData.getCartData(context, token);
                return Center(
                  child: BuildErrorWidget(
                    onRefresh: () async {
                      await cartData.getCartData(context, token);
                      refetch!();
                    },
                    errorMsg: result.exception!.graphqlErrors.isNotEmpty ? result.exception?.graphqlErrors[0].message : "An error occured",
                  ),
                );
                // functionOnException(refetch);
                // return BuildErrorWidget(
                //   errorMsg: result.exception?.graphqlErrors[0].message,
                //   onRefresh: refetch,
                // );
              }
              cartData.setCartData(result.data!);
              cartData.putCartCount(result.data!['cart']['total_quantity']);
              return ListView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 1400 ? (constraints.maxWidth - 1400) / 2 : 20, vertical: 20),
                children: [
                  const SizedBox(height: 20),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  //     width: AppResponsive.isDesktop(context) ? constraints.maxWidth - 410 : constraints.maxWidth,
                  //     decoration: AppResponsive.isDesktop(context)
                  //         ? BoxDecoration(
                  //             color: AppColors.shadowColor,
                  //             borderRadius: BorderRadius.circular(30),
                  //           )
                  //         : null,
                  //     child: const BuildCartSteps(currentCartIndex: 0),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  result.data!['cart']['total_quantity'] == 0
                      ? SizedBox(height: 200, child: Center(child: Text("Cart Empty", style: AppStyles.getMediumTextStyle(fontSize: 18))))
                      : AppResponsive(
                          mobile: Column(
                            children: [
                              getBody(size, cartData, result, refetch),
                              const SizedBox(height: 20),
                              CartSummaryWidget(
                                buttonText: "Proceed To Checkout",
                                refetch: refetch,
                                onButtonTap: _showSignInDialog,
                              ),
                            ],
                          ),
                          desktop: SizedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 75, child: getBody(size, cartData, result, refetch)),
                                const SizedBox(width: 20),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 350),
                                  child: CartSummaryWidget(refetch: refetch, buttonText: "Next", onButtonTap: _showSignInDialog),
                                )
                              ],
                            ),
                          ),
                        ),
                ],
              );
            });
      }),
    );
  }

// If not signed in, proceeds to sign in or continue as guest
  _showSignInDialog() {
    if (token.loginToken != null) {
      return context.go("/${CartView.route}/${CartAddressView.route}");
    }
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              // height: 400,
              child: ListView(
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 20),
                  Center(child: Image.asset(logoUrl, width: 200)),
                  const SizedBox(height: 40),
                  TextButton(
                    style: AppStyles.filledButtonStyle,
                    onPressed: () => context.go('/${Auth.route}'),
                    child: Text(
                      'Sign In & Checkout',
                      style: AppStyles.getMediumTextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    style: AppStyles.outlineButtonStyle,
                    onPressed: () => setState(() {
                      Navigator.pop(context);
                      context.go("/${CartView.route}/${CartAddressView.route}");
                    }),
                    child: Text(
                      'Guest checkout',
                      style: AppStyles.getMediumTextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          fixedSize: const Size(50, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Icon(FontAwesomeIcons.xmark, color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget getBody(Size size, CartData cartData, QueryResult result, Future<QueryResult<Object?>?> Function()? refetch) {
    return AppResponsive(mobile: getMainMobileCart(size, cartData, result, refetch), desktop: getDesktopCartContainer(cartData, result, refetch));
  }

  Container getDesktopCartContainer(CartData cartData, QueryResult result, Future<QueryResult<Object?>?> Function()? refetch) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.evenFadedText),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            height: 70,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Item', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.fontColor)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Price', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.fontColor)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Qty', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.fontColor)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Subtotal', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.fontColor)),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.dividerColor),
          const SizedBox(height: 20),
          Column(
            children: List.generate(
              result.data!['cart']['items'].length,
              (index) {
                var item = result.data!['cart']['items'][index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 4,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                  width: 100,
                                  height: 125,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: AppColors.evenFadedText),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: CachedNetworkImage(imageUrl: item['product']['image']['url']),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(item['product']['name'], style: AppStyles.getMediumTextStyle(fontSize: 15, color: AppColors.fontColor)),
                              ],
                            ),
                          )),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: BuildPriceWithOffer(
                            price: f.format(item['product']['price_range']['minimum_price']['regular_price']['value']),
                            priceSize: 17,
                            currency: item['product']['price_range']['minimum_price']['regular_price']['currency'],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          alignment: Alignment.topLeft,
                          child:
                              getItemNoChanger(size: const Size(500, 50), item: item, mainAxisAlignment: MainAxisAlignment.start, height: 30, cartData: cartData, refetch: refetch),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: BuildPriceWithOffer(
                            price: (f.format(item['product']['price_range']['minimum_price']['regular_price']['value'] * item['quantity'])).toString(),
                            priceSize: 17,
                            currency: item['product']['price_range']['minimum_price']['regular_price']['currency'],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Mutation(
                              options: MutationOptions(
                                document: gql(CartApis.removeProductsFromCart),
                                onCompleted: (data) async {
                                  print(data); // cartData.checkVirtualCart();
                                  showSnackBar(
                                      context: context,
                                      message: "Removed item from cart",
                                      backgroundColor: AppColors.snackbarSuccessBackgroundColor,
                                      textColor: AppColors.snackbarSuccessTextColor);
                                  await cartData.getCartData(context, Provider.of<AuthToken>(context, listen: false));
                                  refetch!();
                                },
                                onError: (error) {
                                  showSnackBar(
                                    context: context,
                                    message: error!.graphqlErrors[0].message,
                                    backgroundColor: AppColors.snackbarErrorBackgroundColor,
                                    textColor: AppColors.snackbarErrorTextColor,
                                  );

                                  print(error);
                                },
                              ),
                              builder: (runMutation, result) {
                                return IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Delete?", style: AppStyles.getMediumTextStyle(fontSize: 16)),
                                        content: Text(
                                          "Are you sure you want to delete this item from cart?",
                                          style: AppStyles.getRegularTextStyle(fontSize: 14),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text(
                                              'Cancel',
                                              style: AppStyles.getMediumTextStyle(fontSize: 14),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              //print(item);
                                              Navigator.pop(context);
                                              runMutation({'cartId': cartData.cartId, 'itemId': item['id']});
                                            },
                                            child: Text(
                                              'OK',
                                              style: AppStyles.getMediumTextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.delete_outline, color: AppColors.primaryColor),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Container getMainMobileCart(Size size, CartData cartData, QueryResult result, Future<QueryResult<Object?>?> Function()? refetch) {
    return Container(
      width: size.width,
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.evenFadedText),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: result.data!['cart']['items'].length,
            separatorBuilder: (context, index) => const SizedBox(height: 30),
            itemBuilder: (context, index) {
              var item = result.data!['cart']['items'][index];
              return Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 100, child: CachedNetworkImage(imageUrl: item['product']['image']['url'])),
                      const SizedBox(height: 15),
                      Text(item['product']['name'], style: AppStyles.getMediumTextStyle(fontSize: 15, color: AppColors.fontColor)),
                      const SizedBox(height: 10),
                      BuildPriceWithOffer(
                        price: f.format(item['product']['special_price'] ?? item['product']['price_range']['minimum_price']['regular_price']['value']),
                        originalPrice: item['product']['price_range']['maximum_price']['regular_price']['value'].toString(),
                        offer: item['product']['price_range']['maximum_price']['discount']['percent_off'] * 1.0,
                        priceSize: 17,
                        currency: item['product']['price_range']['minimum_price']['regular_price']['currency'],
                      ),
                      const SizedBox(height: 10),
                      getItemNoChanger(size: size, item: item, cartData: cartData, refetch: refetch),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Mutation(
                        options: MutationOptions(
                          document: gql(CartApis.removeProductsFromCart),
                          onCompleted: (data) async {
                            print(data); // cartData.checkVirtualCart();
                            showSnackBar(
                                context: context,
                                message: "Removed item from cart",
                                backgroundColor: AppColors.snackbarSuccessBackgroundColor,
                                textColor: AppColors.snackbarSuccessTextColor);
                            // await cartData.getCartData(context, Provider.of<AuthToken>(context, listen: false));
                            refetch!();
                          },
                          onError: (error) {
                            showSnackBar(
                              context: context,
                              message: error!.graphqlErrors[0].message,
                              backgroundColor: AppColors.snackbarErrorBackgroundColor,
                              textColor: AppColors.snackbarErrorTextColor,
                            );

                            print(error);
                          },
                        ),
                        builder: (runMutation, result) {
                          return IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Delete?", style: AppStyles.getMediumTextStyle(fontSize: 16)),
                                  content: Text(
                                    "Are you sure you want to delete this item from cart?",
                                    style: AppStyles.getRegularTextStyle(fontSize: 14),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Cancel',
                                        style: AppStyles.getMediumTextStyle(fontSize: 14),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        //print(item);
                                        Navigator.pop(context);
                                        runMutation({'cartId': cartData.cartId, 'itemId': item['id']});
                                      },
                                      child: Text(
                                        'OK',
                                        style: AppStyles.getMediumTextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.delete_outline, color: AppColors.primaryColor),
                          );
                        }),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 15),
          // Text.rich(
          //   TextSpan(
          //     children: [
          //       TextSpan(text: 'Subtotal', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.fontColor)),
          //       TextSpan(text: '  ₹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.buttonColor)),
          //       TextSpan(
          //         text: '$subTotal',
          //         style: AppStyles.getMediumTextStyle(
          //           fontSize: 18,
          //           color: AppColors.buttonColor,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Row getItemNoChanger({
    required Size size,
    required Map item,
    required CartData cartData,
    required Future<QueryResult<Object?>?> Function()? refetch,
    MainAxisAlignment? mainAxisAlignment,
    double? height,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.evenFadedText),
          ),
          // padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          width: size.width * 0.1,
          height: height ?? 50,
          child: Text(item['quantity'].toString().padLeft(2, '0'), style: AppStyles.getRegularTextStyle(fontSize: 18, color: AppColors.fadedText)),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.evenFadedText),
          ),
          alignment: Alignment.center,
          width: size.width * 0.1,
          height: height ?? 50,
          child: FittedBox(
            child: Mutation(
                options: MutationOptions(
                  document: gql(CartApis.updateCart),
                  onCompleted: (data) async {
                    //print(data);
                    // await cartData.getCartData(context, token);
                    refetch!();
                    setState(() {});
                  },
                  onError: (error) {
                    print(error);
                    showSnackBar(context: context, message: error!.graphqlErrors[0].message, backgroundColor: Colors.red);
                  },
                ),
                builder: (runMutation, result) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // cartList[index].noOfItems++;

                          print(item['quantity']);
                          item['quantity']++;
                          deboucer.run(() {
                            print(item['quantity']);
                            runMutation({
                              "input": {
                                "cart_id": cartData.cartId,
                                "cart_items": [
                                  {"cart_item_id": item['id'], "quantity": item['quantity']}
                                ]
                              }
                            });
                          });
                          setState(() {});
                        },
                        child:
                            SizedBox(width: size.width * 0.1, height: height != null ? height * 0.5 : 24, child: Icon(Icons.expand_less, size: height != null ? height * 0.5 : 24)),
                      ),
                      InkWell(
                        onTap: () {
                          // if (cartList[index].noOfItems != 0) cartList[index].noOfItems--;
                          // if (cartList[index].noOfItems == 0) cartList.removeAt(index);
                          if (item['quantity'] > 1) {
                            setState(() => item['quantity']--);

                            deboucer.run(() {
                              print(item['quantity']);
                              runMutation({
                                "input": {
                                  "cart_id": cartData.cartId,
                                  "cart_items": [
                                    {"cart_item_id": item['id'], "quantity": item['quantity']}
                                  ]
                                }
                              });
                            });
                          }
                          setState(() {});
                        },
                        child:
                            SizedBox(height: height != null ? height * 0.5 : 24, width: size.width * 0.1, child: Icon(Icons.expand_more, size: height != null ? height * 0.5 : 24)),
                      )
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }
}
