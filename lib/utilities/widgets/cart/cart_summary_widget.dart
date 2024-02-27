// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:m2/services/api_services/cart_apis.dart';
import 'package:m2/services/search_services.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';

class CartSummaryWidget extends StatefulWidget {
  const CartSummaryWidget({
    super.key,
    this.estimatedDelivery,
    this.onButtonTap,
    required this.buttonText,
    this.isLoading = false,
    required this.refetch,
  });
  final int? estimatedDelivery;
  final void Function()? onButtonTap;
  final String buttonText;
  final bool isLoading;
  final VoidCallback? refetch;
  @override
  State<CartSummaryWidget> createState() => _CartSummaryWidgetState();
}

class _CartSummaryWidgetState extends State<CartSummaryWidget> {
  TextEditingController coupon = TextEditingController();
  bool isAppliedCoupon = false;
  var f = NumberFormat("#,##,##,##0.00", "en_IN");
  MaterialStatesController buttonStateController = MaterialStatesController();
  bool isLoading = false;
  late AuthToken authToken;
  late CartData cart;

  Debouncer debouncer = Debouncer(milliseconds: 700);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getData());
  }

  getData() {
    coupon = TextEditingController(text: cart.cartData['cart']['applied_coupons']?[0]['code'] ?? '');

    log(cart.cartData['cart']['applied_coupons'].toString());
    isAppliedCoupon = cart.cartData['cart']['applied_coupons'] != null;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    coupon.dispose();
    buttonStateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    cart = Provider.of<CartData>(context);
    authToken = Provider.of<AuthToken>(context);

    return Observer(builder: (context) {
      return Container(
        width: size.width,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.all(size.width * 0.05 > 40 ? 40 : size.width * 0.05),
        decoration: BoxDecoration(
          color: AppColors.dividerColor,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.estimatedDelivery != null)
              Text('Expected Delivery By: ${widget.estimatedDelivery} days', style: AppStyles.getRegularTextStyle(fontSize: 18, color: AppColors.buttonColor)),
            if (widget.estimatedDelivery != null) const SizedBox(height: 20),
            Text(
              'Summary',
              style: AppStyles.getMediumTextStyle(fontSize: 22, color: AppColors.fontColor),
              softWrap: false,
            ),
            const SizedBox(height: 10),
            CartAmountListing(
              title: 'Subtotal',
              currency: cart.cartData['cart']['prices']['subtotal_including_tax']['currency'],
              money: double.parse(cart.cartData['cart']['prices']['subtotal_including_tax']['value'].toString()),
            ),
            const SizedBox(height: 10),
            if (cart.cartData['cart']['applied_coupons'] != null)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cart.cartData['cart']['prices']['discounts'].length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) => CartAmountListing(
                  title: cart.cartData['cart']['prices']['discounts'][index]['label'],
                  money: double.parse(cart.cartData['cart']['prices']['discounts'][index]['amount']['value'].toString()),
                  currency: cart.cartData['cart']['prices']['discounts'][index]['amount']['currency'],
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    flex: 70,
                    child: TextFormField(
                      controller: coupon,
                      // initialValue: ' coupon.text',
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        border: OutlineInputBorder(
                          gapPadding: 0,
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: AppColors.evenFadedText),
                        ),
                        hintStyle: AppStyles.getExtraLightTextStyle(fontSize: 13, color: AppColors.fadedText),
                        hintText: 'Enter your code',
                      ),
                      style: AppStyles.getExtraLightTextStyle(fontSize: 13, color: AppColors.fadedText),
                      // validator: (value) => value != '' ? null : 'Enter Coupon code',
                    ),
                  ),
                  Mutation(
                      options: MutationOptions(
                        onCompleted: (data) async {
                          print('$data');
                          if (data != null) {
                            // setState(() {
                            //   isAppliedCoupon = !isAppliedCoupon;
                            // });
                            showSnackBar(
                              backgroundColor: AppColors.snackbarSuccessBackgroundColor,
                              textColor: AppColors.snackbarSuccessTextColor,
                              context: context,
                              message: cart.cartData['cart']['applied_coupons'] == null ? 'Coupon Applied SuccessFully' : 'Coupon Removed SuccessFully',
                            );
                          }
                          if (widget.refetch != null) {
                            widget.refetch!();
                          } else {
                            cart.getCartData(context, authToken);
                          }
                        },
                        onError: (error) {
                          print('$error');
                          showSnackBar(
                            backgroundColor: AppColors.snackbarErrorBackgroundColor,
                            textColor: AppColors.snackbarErrorTextColor,
                            context: context,
                            message: error!.graphqlErrors[0].message,
                          );
                        },
                        document: gql(cart.cartData['cart']['applied_coupons'] == null ? CartApis.applyCouponToCart : CartApis.removeCouponFromCart),
                      ),
                      builder: (runMutation, result) {
                        return InkWell(
                          onTap: () {
                            if (cart.cartData['cart']['applied_coupons'] == null) {
                              log('messagerrrg');
                              Map<String, dynamic> data = {'cartID': cart.cartId, 'couponCode': coupon.text};
                              runMutation(data);
                            } else {
                              log('messagerr');
                              Map<String, dynamic> data = {'cartId': cart.cartId};
                              runMutation(data);
                              coupon.clear();
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 90,
                            color: AppColors.buttonColor,
                            alignment: Alignment.center,
                            child: Text(
                              cart.cartData['cart']['applied_coupons'] == null ? 'Apply Discount' : 'Discard coupon',
                              style: AppStyles.getRegularTextStyle(fontSize: 11, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: AppColors.fadedText, height: 1),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.spaceBetween,
              spacing: 20,
              runSpacing: 20,
              children: [
                Text('Order Total', style: AppStyles.getSemiBoldTextStyle(fontSize: 20, color: AppColors.fontColor)),
                Text.rich(
                  TextSpan(
                    children: [
                      if (cart.cartData['cart']['prices']['grand_total']['currency'] != null)
                        TextSpan(
                            text: '${cart.cartData['cart']['prices']['grand_total']['currency']} ',
                            style: AppStyles.getSemiBoldTextStyle(fontSize: 20, color: AppColors.fontColor)),
                      TextSpan(
                          text: f.format(cart.cartData['cart']['prices']['grand_total']['value']), style: AppStyles.getMediumTextStyle(fontSize: 20, color: AppColors.fontColor))
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              // style: TextButton.styleFrom(
              //   fixedSize: Size(size.width * 0.8, size.width * 0.125),
              //   maximumSize: Size(250, 50),
              //   shape: StadiumBorder(side: BorderSide(width: 2, color: AppColors.buttonColor)),
              //   shadowColor: AppColors.shadowColor,
              // ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(StadiumBorder(side: BorderSide(width: 2, color: AppColors.buttonColor))),
                shadowColor: MaterialStateProperty.all(AppColors.shadowColor),
                backgroundColor: MaterialStateProperty.resolveWith(getButtonColor),
                foregroundColor: MaterialStateProperty.resolveWith(getTextColor),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              ),
              statesController: buttonStateController,
              onPressed: widget.onButtonTap,
              child: widget.isLoading
                  ? const BuildLoadingWidget()
                  : Text(
                      widget.buttonText,
                      style: AppStyles.getRegularTextStyle(
                        fontSize: 20,
                      ),
                    ),
            ),
            // const SizedBox(height: 40),
          ],
        ),
      );
    });
  }
}

applyDiscount() {}
