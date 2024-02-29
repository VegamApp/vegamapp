// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
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
  String? orderId;
  late CartData cartData;
  late AuthToken authToken;
  String? brainTreeToken;
  final _razorPay = Razorpay();

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

    // get graphql client
    var graphqlClient = GraphQLProvider.of(context);

    // make input for setRzpPaymentDetailsForOrder mutation
    var input = {
      'order_id': orderId,
      'rzp_payment_id': response.paymentId,
      'rzp_signature': response.signature,
    };

    // run mutations
    QueryResult? result = await graphqlClient.value.mutate(
      MutationOptions(document: gql(PaymentServices.setRzpPaymentDetailsForOrder), variables: {"input": input}),
    );

    // On succes, reset cart.
    if (!result.hasException) {
      QueryResult? newResult = await graphqlClient.value.mutate(
        MutationOptions(document: gql(PaymentServices.resetCart), variables: {"id": orderId}),
      );
      if (!newResult.hasException) {
        context.go("/${CartView.route}/${OrderPlacedView.route}?orderid=$orderId");
      } else {
        cartData.getCartData(context, authToken);
      }
    } else {
      showSnackBar(context: context, message: result.exception!.graphqlErrors[0].message, backgroundColor: Colors.red);
      cartData.getCartData(context, authToken);
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
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    cartData = Provider.of<CartData>(context);
    authToken = Provider.of<AuthToken>(context);
    return BuildScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
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
              // log(jsonEncode(result.data));
              cartData.setCartData(cartData.cartData);
              cartData.putCartCount(cartData.cartData['cart']['total_quantity']);

              if (result.data!['cart']['shipping_addresses'].isEmpty) {
                context.go("/${CartView.route}");
              }

              if (result.data!['cart']['selected_payment_method'] != null) {
                paymentCode ??= result.data!['cart']['selected_payment_method']['code'];
              }
              if (result.data!['cart']['shipping_addresses'][0]['selected_shipping_method'] != null) {
                selectedShippingMethod ??= result.data!['cart']['shipping_addresses'][0]['selected_shipping_method']['carrier_code'];
              }

              return Mutation(
                  options: MutationOptions(
                    document: gql(PaymentServices.placeOrder),
                    onError: (data) {
                      print(data);
                      try {
                        showSnackBar(context: context, message: data!.graphqlErrors[0].message, backgroundColor: Colors.red);
                      } catch (e) {
                        //print(e);
                      }
                    },
                    onCompleted: (data) async {
                      if (data != null) {
                        log(data.toString());
                        if (paymentCode == 'razorpay') {
                          getRazorPayId(data);
                        } else {
                          if (authToken.loginToken == null) {
                            cartData.getGuestCart(context);
                          } else {
                            await cartData.getCustomerCart(context, authToken);
                          }
                          cartData.getCartData(context, authToken);
                          context.go("/${CartView.route}/${OrderPlacedView.route}");
                        }
                      }
                      // navigate(context, RazorPayWeb());
                    },
                  ),
                  builder: (runMutation, mutResult) {
                    return AppResponsive(
                      mobile: ListView(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 1400 ? (constraints.maxWidth - 1400) / 2 : 20, vertical: 20),
                        children: [
                          getBody(size, cartData, refetch),
                          const SizedBox(height: 20),
                          CartSummaryWidget(
                            refetch: refetch,
                            buttonText: "Place Order",
                            isLoading: isLoading || mutResult!.isLoading,
                            onButtonTap: () {
                              if (!mutResult!.isLoading && !cartData.isLoading) {
                                if (paymentCode == null) {
                                  showSnackBar(context: context, message: 'Select a payment method', backgroundColor: Colors.red);
                                  return;
                                }
                                // if (paymentCode == 'braintree') {
                                //   // brainTreeSetup(token);
                                //   return;
                                // }
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
                                refetch: refetch,
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
          // show shipping methods
          Text('Shipping Method', style: AppStyles.getMediumTextStyle(fontSize: 16, color: AppColors.primaryColor)),
          const SizedBox(height: 20),
          if (cartData.cartData['cart']?['shipping_addresses'] != null && cartData.cartData['cart']?['shipping_addresses'].isNotEmpty)
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
                          width: size.width * 0.35,
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
                                      style: AppStyles.getMediumTextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${shippingMethod['amount']['currency']} ${shippingMethod['amount']['value']}',
                                      textAlign: TextAlign.center,
                                      style: AppStyles.getMediumTextStyle(fontSize: 12, color: AppColors.primaryColor),
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
          // Show available payment methods
          Text('Payment Method', style: AppStyles.getMediumTextStyle(fontSize: 16, color: AppColors.primaryColor)),
          const SizedBox(height: 20),
          if (cartData.cartData['cart']?['available_payment_methods'] != null)
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
                        onTap: () async {
                          // Clipboard.setData(ClipboardData(text: jsonEncode(cartData.cartData)));
                          setState(() => paymentCode = paymentMethod['code']);
                          Map<String, dynamic> mutationParams = {
                            'cartId': cartData.cartId,
                            'paymentMethod': {'code': paymentCode}
                          };
                          if (paymentCode == "braintree") {
                            brainTreeToken = await createBraintreeToken();
                            mutationParams["paymentMethod"] = {
                              'code': paymentCode,
                              "braintree": {"payment_method_nonce": brainTreeToken, "is_active_payment_token_enabler": false}
                            };
                          }
                          runMutation(mutationParams);

                          // setState(() {});
                        },
                        child: Container(
                          width: size.width * 0.35,
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
                          child: mutationResult!.isLoading && paymentCode == paymentMethod['code']
                              ? BuildLoadingWidget(color: AppColors.primaryColor)
                              : Center(
                                  child: Text(
                                    paymentMethod['title'],
                                    textAlign: TextAlign.center,
                                    style: AppStyles.getMediumTextStyle(fontSize: 14),
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

// Create braintree token
  Future<String?> createBraintreeToken() async {
    var graphqlClient = GraphQLProvider.of(context);
    var data = await graphqlClient.value.mutate(MutationOptions(document: gql(PaymentServices.createBraintreeClientToken)));
    log(data.toString());
    if (data.hasException) {
      try {
        showSnackBar(context: context, message: data.exception!.graphqlErrors[0].message, backgroundColor: AppColors.snackbarErrorBackgroundColor);
      } catch (e) {
        showSnackBar(context: context, message: "An error occured! Please try later.", backgroundColor: AppColors.snackbarErrorBackgroundColor);
      }
      return null;
    }

    var token = data.data?['createBraintreeClientToken'];

    // Process the token into BraintreeDropInRequest
    final request = BraintreeDropInRequest(
      clientToken: token,
      amount: cartData.cartData['cart']['prices']['grand_total']['value'].toString(),
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: cartData.cartData['cart']['prices']['grand_total']['value'].toString(),
        currencyCode: cartData.cartData['cart']['prices']['grand_total']['currency'].toString(),
        billingAddressRequired: false,
      ),
      // paypalRequest: BraintreePayPalRequest(
      //   amount: cartData.cartData['cart']['prices']['grand_total']['value'].toString(),
      //   displayName: 'Vegam',
      // ),
    );

    BraintreeDropInResult? result = await BraintreeDropIn.start(request);
    if (result != null) {
      print('Nonce: ${result.paymentMethodNonce.nonce}');
      return result.paymentMethodNonce.nonce;
    } else {
      print('Selection was canceled.');
      return null;
    }
  }

  getRazorPayId(data) async {
    final graphqlClient = GraphQLProvider.of(context);
    orderId = data['placeOrder']['order']['order_number'];
    var rzrData = await graphqlClient.value.mutate(MutationOptions(document: gql(PaymentServices.placeRazorpayOrder), variables: {'id': orderId}));
    log(rzrData.toString());
    if (!rzrData.hasException) {
      getRazorPayInterface(orderId: rzrData.data!['placeRazorpayOrder']['rzp_order_id'], amountData: rzrData.data!['placeRazorpayOrder']['amount']);
    }
  }

  getRazorPayInterface({var orderId, var amountData}) async {
    var userData = Provider.of<UserData>(context, listen: false);
    try {
      double amount = double.parse(amountData.toString());
      amount = amount * 100;

      var options = {
        //test
        // Insert your key here
        'key': 'rzp_test_kviuSU4uhhoBlr',
        // "description": storeConfig.storeData.storeConfig?.defaultDescription ?? "",
        'amount': amount.floor(), //in the smallest currency sub-unit.
        'name': 'Vegam',
        'order_id': orderId,
        // Generate order_id using Orders API
        // 'description': 'Fine T-Shirt',
        'timeout': 300, // in seconds
        'prefill': {
          'name': '${cartData.cartData['cart']['billing_address']['firstname']} ${cartData.cartData['cart']['billing_address']['lastname']}',
          // 'contact': userData.data.,
          'email': userData.data.email,
        },
        "theme": {"color": '#${AppColors.primaryColor.value.toRadixString(16)}'}
      };
      log(jsonEncode(options));

      _razorPay.open(options);
    } catch (e) {
      print(e);
      await cartData.getCartData(context, Provider.of<AuthToken>(context, listen: false));
    }
  }
}
