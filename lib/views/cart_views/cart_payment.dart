import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/cart_apis.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/cart_views/cart_view.dart';
import 'package:m2/views/cart_views/payment_complete_view.dart';
import 'package:provider/provider.dart';

class CartPayment extends StatefulWidget {
  const CartPayment({super.key});
  static String route = 'payment';
  @override
  State<CartPayment> createState() => _CartPaymentState();
}

class _CartPaymentState extends State<CartPayment> {
  ScrollController scrollController = ScrollController();
  String? paymentCode;
  String? selectedShippingMethod;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // log(jsonEncode(cartData.cartData));
    return BuildScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
        return Observer(builder: (_) {
          var cartData = Provider.of<CartData>(context);
          var token = Provider.of<AuthToken>(context);

          if (cartData.isLoading) {
            return const BuildLoadingWidget();
          }
          if (cartData.cartData.isEmpty) {
            return BuildErrorWidget(
              errorMsg: 'An error occured, please try again.',
              onRefresh: () => cartData.getCartData(context, token),
            );
          }
          return Query(
              options: QueryOptions(document: CartApis.cart, variables: {'id': cartData.cartId}),
              builder: (result, {fetchMore, refetch}) {
                if (result.isLoading && result.data == null) {
                  return const BuildLoadingWidget();
                }
                if (result.hasException) {
                  return BuildErrorWidget(
                    errorMsg: result.exception?.graphqlErrors[0].message,
                    onRefresh: refetch,
                  );
                }
                log(jsonEncode(result.data));
                cartData.setCartData(cartData.cartData);
                cartData.putCartCount(cartData.cartData['cart']['total_quantity']);

                if (result.data!['cart']['shipping_addresses'].isEmpty) {
                  context.go("/${CartView.route}");
                }

                if (result.data!['cart']['selected_payment_method'] != null) {
                  paymentCode = result.data!['cart']['selected_payment_method']['code'];
                }
                if (result.data!['cart']['shipping_addresses'][0]['selected_shipping_method'] != null) {
                  selectedShippingMethod = result.data!['cart']['shipping_addresses'][0]['selected_shipping_method']['carrier_code'];
                }

                return ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        width: AppResponsive.isDesktop(context) ? constraints.maxWidth - 410 : constraints.maxWidth,
                        decoration: AppResponsive.isDesktop(context)
                            ? BoxDecoration(
                                color: AppColors.shadowColor,
                                borderRadius: BorderRadius.circular(30),
                              )
                            : null,
                        child: const BuildCartSteps(currentCartIndex: 2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppResponsive(
                      mobile: Column(
                        children: [
                          getBody(size, cartData, refetch),
                          const SizedBox(height: 20),
                          CartSummaryWidget(
                            buttonText: "Go to Checkout",
                            onButtonTap: () {
                              context.go("/${CartView.route}/${OrderPlacedView.route}");
                            },
                          ),
                        ],
                      ),
                      desktop: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 75, child: getBody(size, cartData, refetch)),
                            const SizedBox(width: 20),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 350),
                              child: CartSummaryWidget(
                                buttonText: "Go to Checkout",
                                onButtonTap: () {
                                  context.go("/${CartView.route}/${OrderPlacedView.route}");
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              });
        });
      }),
    );
  }

  getBody(Size size, CartData cartData, Future<QueryResult<Object?>?> Function()? refetch) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.evenFadedText),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shipping Method', style: AppStyles.getMediumTextStyle(fontSize: 16, color: AppColors.primaryColor)),
          const SizedBox(height: 20),
          Mutation(
            options: MutationOptions(
                document: gql(CartApis.setShippingMethod),
                onError: (data) {
                  print(data);
                },
                onCompleted: (data) {
                  print(data);
                  refetch!();
                }),
            builder: (runMutation, mutationResult) {
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(
                  // cardUrls.length,
                  cartData.cartData['cart']['shipping_addresses'][0]['available_shipping_methods'].length,
                  (index) {
                    var shippingMethod = cartData.cartData['cart']['shipping_addresses'][0]['available_shipping_methods'][index];
                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() => selectedShippingMethod = shippingMethod['carrier_code']);
                        print(selectedShippingMethod);
                        runMutation({
                          'cartId': cartData.cartId,
                          'shippingMethod': [
                            {
                              'carrier_code': cartData.cartData['cart']['shipping_addresses'][0]['available_shipping_methods'][index]['carrier_code'],
                              'method_code': cartData.cartData['cart']['shipping_addresses'][0]['available_shipping_methods'][index]['method_code']
                            }
                          ]
                        });

                        // setState(() {});
                      },
                      child: Container(
                        width: size.width * 0.4,
                        height: size.width * 0.2,
                        constraints: const BoxConstraints(maxWidth: 200, maxHeight: 100),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            width: 2.0,
                            color: selectedShippingMethod == shippingMethod['carrier_code'] ? const Color(0xff31aca0) : AppColors.evenFadedText,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x03000000),
                              offset: Offset(0, 30),
                              blurRadius: 50,
                            ),
                          ],
                        ),
                        // child: Image.asset('assets/images/${cardUrls[index]}'),
                        child: mutationResult!.isLoading && selectedShippingMethod != shippingMethod['carrier_code']
                            ? BuildLoadingWidget(color: AppColors.primaryColor)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    shippingMethod['carrier_title'],
                                    textAlign: TextAlign.center,
                                    style: AppStyles.getMediumTextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${shippingMethod['amount']['currency']} ${shippingMethod['amount']['value']}',
                                    textAlign: TextAlign.center,
                                    style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.primaryColor),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          Text('Payment Method', style: AppStyles.getMediumTextStyle(fontSize: 16, color: AppColors.primaryColor)),
          const SizedBox(height: 20),
          Mutation(
            options: MutationOptions(
                document: gql(CartApis.setPaymentMethodOnCart),
                onError: (data) {
                  print(data);
                },
                onCompleted: (data) {
                  print(data);
                  refetch!();
                }),
            builder: (runMutation, mutationResult) {
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(
                  // cardUrls.length,
                  cartData.cartData['cart']['available_payment_methods'].length,
                  (index) {
                    var paymentMethod = cartData.cartData['cart']['available_payment_methods'][index];
                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() => paymentCode = paymentMethod['code']);
                        runMutation({
                          'cartId': cartData.cartId,
                          'paymentMethod': {'code': paymentCode}
                        });

                        // setState(() {});
                      },
                      child: Container(
                        width: size.width * 0.4,
                        height: size.width * 0.2,
                        constraints: const BoxConstraints(maxWidth: 200, maxHeight: 100),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8.0),
                          border:
                              Border.all(width: 2.0, color: paymentCode == paymentMethod['code'] ? const Color(0xff31aca0) : AppColors.evenFadedText),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x03000000),
                              offset: Offset(0, 30),
                              blurRadius: 50,
                            ),
                          ],
                        ),
                        // child: Image.asset('assets/images/${cardUrls[index]}'),
                        child: mutationResult!.isLoading && paymentCode != paymentMethod['code']
                            ? BuildLoadingWidget(color: AppColors.primaryColor)
                            : Center(
                                child: Text(
                                  paymentMethod['title'],
                                  textAlign: TextAlign.center,
                                  style: AppStyles.getMediumTextStyle(fontSize: 16),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
