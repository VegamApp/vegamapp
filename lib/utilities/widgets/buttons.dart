import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/cart_apis.dart';
import 'package:m2/services/api_services/product_apis.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/loading_builder.dart';
import 'package:provider/provider.dart';

class BuildButtonSingle extends StatefulWidget {
  const BuildButtonSingle({
    Key? key,
    required this.typeName,
    required this.width,
    required this.title,
    required this.buttonColor,
    required this.textColor,
    required this.svg,
    required this.parentSku,
    this.selectedSku,
    this.isBuyNow = false,
    this.margin,
    required this.quantity,
  }) : super(key: key);

  final EdgeInsets? margin;
  final String typeName;
  final double width;
  final String svg;
  final String title;
  final Color buttonColor;
  final Color textColor;
  final String parentSku;
  final String? selectedSku;
  final bool isBuyNow;
  final double quantity;
  @override
  State<BuildButtonSingle> createState() => _BuildButtonSingleState();
}

class _BuildButtonSingleState extends State<BuildButtonSingle> {
  late Color textButtonColor;
  late Color textColor;
  @override
  void initState() {
    super.initState();
    textButtonColor = widget.buttonColor;
    textColor = widget.textColor;
  }

  @override
  Widget build(BuildContext context) {
    final loginToken = Provider.of<AuthToken>(context);
    var cart = Provider.of<CartData>(context);

    return Mutation(
        options: MutationOptions(
            document: gql(CartApis.addProductToCart),
            onCompleted: (result) {
              //print("result: $result");
              try {
                cart.putCartCount(result!['addProductsToCart']['cart']['total_quantity']);
                cart.getCartData(context);
                try {
                  showSnackBar(
                    backgroundColor: AppColors.snackbarErrorBackgroundColor,
                    textColor: AppColors.snackbarErrorTextColor,
                    context: context,
                    message: result['addProductsToCart']['user_errors'][0]['message'],
                  );
                } catch (e) {
                  showSnackBar(
                    backgroundColor: AppColors.snackbarSuccessBackgroundColor,
                    textColor: AppColors.snackbarSuccessTextColor,
                    context: context,
                    message: 'Added to cart',
                  );
                  if (widget.isBuyNow) {
                    if (loginToken.loginToken == null) {
                      // navigate(context, const Auth());
                    } else {
                      // navigate(context, const GuestShippingView());
                    }
                  }
                }
              } catch (e) {
                //print(e);
              }
            },
            onError: (data) {
              //print(data);
            }),
        builder: (RunMutation runMutation, QueryResult? result) {
          // if (result!.isLoading) {
          //   return Container(
          //     width: widget.width * 0.4,
          //     height: widget.width * 0.1,
          //     constraints: const BoxConstraints(maxWidth: 160, maxHeight: 40),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(widget.width * 0.05),
          //       border: Border.all(width: 2, color: widget.buttonColor),
          //     ),
          //     child: Center(
          //         child: Container(
          //             width: widget.width * 0.075,
          //             height: widget.width * 0.075,
          //             constraints: const BoxConstraints(maxWidth: 30, maxHeight: 30),
          //             child: CircularProgressIndicator(color: widget.buttonColor, strokeWidth: 2))),
          //   );
          // }
          return TextButton(
            onHover: (value) {
              if (value) {
                textButtonColor = AppColors.containerColor;
                textColor = widget.buttonColor;
              } else {
                textButtonColor = widget.buttonColor;
                textColor = widget.textColor;
              }
              setState(() {});
            },
            style: TextButton.styleFrom(
              // fixedSize: Size(widget.width * 0.4, widget.width * 0.1),
              maximumSize: const Size.fromHeight(40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.width * 0.05),
                side: BorderSide(width: 2, color: widget.buttonColor),
              ),
              backgroundColor: textButtonColor,
              shadowColor: AppColors.shadowColor,
              padding: const EdgeInsets.all(10),
            ),
            onPressed: () {
              print(widget.typeName);
              print(widget.parentSku);
              print(widget.selectedSku);
              if (widget.typeName == 'ConfigurableProduct') {
                runMutation({
                  'cartIdString': '${cart.cartId}',
                  'cartItemsMap': [
                    {
                      'quantity': 1,
                      'parent_sku': widget.parentSku,
                      'sku': widget.selectedSku,
                    }
                  ]
                });
              } else if (widget.typeName == 'SimpleProduct') {
                //print(loginToken.cartId);
                runMutation({
                  'cartIdString': '${cart.cartId}',
                  'cartItemsMap': [
                    {'quantity': 1, 'sku': widget.parentSku}
                  ]
                });
              } else {
                runMutation({
                  'cartIdString': cart.cartId,
                  'cartItemsMap': [
                    {'quantity': 1, 'sku': widget.parentSku}
                  ]
                });
              }
            },
            child: result!.isLoading
                ? BuildLoadingWidget(color: textColor)
                : Stack(
                    children: [
                      Center(
                        child: Text(
                          widget.title,
                          style: AppStyles.getMediumTextStyle(fontSize: widget.width * 0.028 > 14 ? 14 : widget.width * 0.028, color: textColor),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(
                          widget.svg,
                          color: textColor,
                          width: widget.width * 0.08 > 30 ? 30 : widget.width * 0.08,
                        ),
                      )
                    ],
                  ),
          );
        });
  }
}
