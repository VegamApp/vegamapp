// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/cart_apis.dart';
import 'package:m2/services/api_services/payment_services.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/services/state_management/user/user_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/cart_views/cart_view.dart';
import 'package:m2/views/cart_views/payment_complete_view.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';

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
  late CartData cartData;
  late AuthToken authToken;
  var _razorPay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    _razorPay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("success ${response.orderId}");

    // Do something when payment succeeds
    setState(() {
      isLoading = true;
    });

    showSnackBar(context: context, message: "Payment Successfull", backgroundColor: AppColors.snackbarSuccessBackgroundColor);

    var graphqlClient = GraphQLProvider.of(context);
    var input = {
      'cart_id': cartData.cartId,
      'rzp_order_id': response.orderId,
      'rzp_payment_id': response.paymentId,
      'rzp_signature': response.signature,
    };
    log(input.toString());
    QueryResult? result = await graphqlClient.value.mutate(
      MutationOptions(document: gql(PaymentServices.setRazorOnCart), variables: {"input": input}),
    );

    try {} catch (e) {}
    if (!result.hasException) {
      QueryResult? placeOrderresult = await graphqlClient.value.mutate(
        MutationOptions(document: gql(PaymentServices.placeOrder), variables: {'cartId': cartData.cartId}),
      );
      if (!placeOrderresult.hasException) {
        CartData cartData = Provider.of<CartData>(context, listen: false);
        AuthToken authToken = Provider.of<AuthToken>(context, listen: false);
        await cartData.getCustomerCart(context, authToken);
        context.push("/${CartView.route}/${OrderPlacedView.route}?orderid=${placeOrderresult.data?['placeOrder']['order']['order_number']}");
      }
    } else {
      showSnackBar(context: context, message: result.exception!.graphqlErrors[0].message, backgroundColor: Colors.red);
    }
    setState(() {
      isLoading = false;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    print("error ${response.message}");
    // Do something when payment fails
    showSnackBar(context: context, message: response.message ?? "An error occured. Please try again.", backgroundColor: AppColors.snackbarErrorBackgroundColor);
    await cartData.getCartData(context, authToken);
    ////print(response.message);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message!, style: AppStyles.getRegularTextStyle(fontSize: 14))));
    // await fetchNewCart();
    // Navigator.pushAndRemoveUntil(context, PageTransition(child: HomeView(), type: PageTransitionType.fade), (route) => false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    // Do something when an external wallet is selected
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unknown Error", style: AppStyles.getRegularTextStyle(fontSize: 14))));
    // await fetchNewCart();

    // Navigator.pushAndRemoveUntil(context, PageTransition(child: HomeView(), type: PageTransitionType.fade), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // log(jsonEncode(cartData.cartData));
    return BuildScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
        return Observer(builder: (_) {
          cartData = Provider.of<CartData>(context);
          authToken = Provider.of<AuthToken>(context);

          if (cartData.isLoading) {
            return const BuildLoadingWidget();
          }
          if (cartData.cartData.isEmpty) {
            return BuildErrorWidget(
              errorMsg: 'An error occured, please try again.',
              onRefresh: () => cartData.getCartData(context, authToken),
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
                  padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 1400 ? (constraints.maxWidth - 1400) / 2 : 60, vertical: 20),
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
                    Mutation(
                        options: MutationOptions(
                          document: gql(paymentCode == 'razorpay' ? PaymentServices.placeRazorPayOrder : PaymentServices.placeOrder),
                          onError: (data) {
                            print(data);
                            try {
                              showSnackBar(context: context, message: data!.graphqlErrors[0].message, backgroundColor: Colors.red);
                            } catch (e) {
                              //print(e);
                            }
                          },
                          onCompleted: (data) async {
                            print(data);
                            if (data != null) {
                              log(data.toString());
                              if (paymentCode == 'razorpay') {
                                if (data['placeRazorpayOrder']['success']) {
                                  getRazorPay(data, authToken);
                                } else {
                                  showSnackBar(context: context, message: data['placeRazorpayOrder']['message'], backgroundColor: Colors.red);
                                }
                              } else {
                                await cartData.getCustomerCart(context, authToken);
                                context.go("/${CartView.route}/${OrderPlacedView.route}");
                              }
                            }
                            // navigate(context, RazorPayWeb());
                          },
                        ),
                        builder: (runMutation, mutResult) {
                          return AppResponsive(
                            mobile: Column(
                              children: [
                                getBody(size, cartData, refetch),
                                const SizedBox(height: 20),
                                CartSummaryWidget(
                                  buttonText: "Place Order",
                                  isLoading: isLoading,
                                  onButtonTap: () {
                                    if (!mutResult!.isLoading && !cartData.isLoading) {
                                      if (paymentCode == null) {
                                        showSnackBar(context: context, message: 'Select a payment method', backgroundColor: Colors.red);
                                        return;
                                      }
                                      runMutation({
                                        'cartId': cartData.cartId,
                                      });
                                    }
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
                                      buttonText: "Place Order",
                                      isLoading: isLoading,
                                      onButtonTap: () {
                                        if (!mutResult!.isLoading && !cartData.isLoading) {
                                          if (paymentCode == null) {
                                            showSnackBar(context: context, message: 'Select a payment method', backgroundColor: Colors.red);
                                            return;
                                          }
                                          runMutation({
                                            'cartId': cartData.cartId,
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
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
                          border: Border.all(width: 2.0, color: paymentCode == paymentMethod['code'] ? const Color(0xff31aca0) : AppColors.evenFadedText),
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

  getRazorPay(data, AuthToken authToken) async {
    // KalyanStoreConfig storeConfig = Provider.of<KalyanStoreConfig>(context, listen: false);
    var userData = Provider.of<UserData>(context, listen: false);
    print(data);
    // log(jsonEncode(cartData.cartData));
    try {
      double amount = double.parse(data['placeRazorpayOrder']['amount']);
      ////print('amount $amount');
      amount = amount * 100;
      amount.floor();

      var options = {
        //test
        'key': 'rzp_test_KlUME9CyoNI00x',
        // live
        // 'key': 'rzp_live_1LicnHl9VVn03e',
        // "description": storeConfig.storeData.storeConfig?.defaultDescription ?? "",
        'amount': amount.floor(), //in the smallest currency sub-unit.
        'name': 'M2',
        'order_id': data['placeRazorpayOrder']['rzp_order_id'],
        // 'order': {"order_id": data['placeRazorpayOrder']['rzp_order_id']},
        // Generate order_id using Orders API
        // 'description': 'Fine T-Shirt',
        'timeout': 300, // in seconds
        'prefill': {
          'name': '${cartData.cartData['cart']['billing_address']['firstname']} ${cartData.cartData['cart']['billing_address']['lastname']}',
          // 'contact': userData.data.,
          'email': userData.data.email,
        },
        "theme": {"color": "#0E887C"}
      };
      log(jsonEncode(options));

      _razorPay.open(options);
    } catch (e) {
      print(e);
      // await APIServices().refreshCart();
    }
  }
}
