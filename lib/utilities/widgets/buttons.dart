
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/cart_apis.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/loading_builder.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/cart_views/cart_view.dart';
import 'package:provider/provider.dart';

class BuildButtonSingle extends StatefulWidget {
  const BuildButtonSingle({
    super.key,
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
  });

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
  MaterialStatesController statesController = MaterialStatesController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginToken = Provider.of<AuthToken>(context);
    var cart = Provider.of<CartData>(context);
    var token = Provider.of<AuthToken>(context);

    return Mutation(
        options: MutationOptions(
            document: gql(CartApis.addProductToCart),
            onCompleted: (result) {
              print(result);
              cart.putCartCount(result?['addProductsToCart']['cart']['total_quantity']);
              // Timer(const Duration(milliseconds: 1000), () => cart.getCartData(context, token));
              print(cart.cartCount);
              try {
                try {
                  showSnackBar(
                    backgroundColor: AppColors.snackbarErrorBackgroundColor,
                    textColor: AppColors.snackbarErrorTextColor,
                    context: context,
                    message: result?['addProductsToCart']['user_errors'][0]['message'],
                  );
                } catch (e) {
                  print(e);
                  showSnackBar(
                    backgroundColor: AppColors.snackbarSuccessBackgroundColor,
                    textColor: AppColors.snackbarSuccessTextColor,
                    context: context,
                    message: 'Added to cart',
                  );
                  // cart.getCartData(context, token);
                  if (widget.isBuyNow) {
                    if (loginToken.loginToken == null) {
                      // navigate(context, const Auth());
                      context.pushNamed(Auth.route);
                    } else {
                      context.pushNamed(CartView.route);
                      // navigate(context, const GuestShippingView());
                    }
                  }
                }
              } catch (e) {
                print(e);
              }
            },
            onError: (data) {
              print("addProductToCarterror $data");
              try {
                if (data!.graphqlErrors[0].extensions!['category'] == "graphql-authorization") {
                  cart.getCartData(context, token);
                  showSnackBar(context: context, message: "Error occured, please try again.", backgroundColor: AppColors.snackbarErrorBackgroundColor);
                }
              } catch (e) {}
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
            style: ButtonStyle(
              // fixedSize: Size(widget.width * 0.4, widget.width * 0.1),
              maximumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
              shape: MaterialStateProperty.all(StadiumBorder(side: BorderSide(color: widget.buttonColor, width: 2))),
              backgroundColor: MaterialStateProperty.resolveWith(getButtonColor),
              foregroundColor: MaterialStateProperty.resolveWith(getTextColor),
              padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
            ),
            statesController: statesController,
            onHover: (value) => setState(() {}),
            onPressed: () {
              print(widget.typeName);
              // print(widget.parentSku);
              // print(widget.selectedSku);
              if (widget.typeName == 'ConfigurableProduct') {
                Map<String, dynamic> data = {
                  'cartIdString': '${cart.cartId}',
                  'cartItemsMap': [
                    {
                      'parent_sku': widget.parentSku,
                      'quantity': widget.quantity,
                      'sku': widget.selectedSku,
                    }
                  ]
                };
                print('data $data');
                runMutation(data);
              } else if (widget.typeName == 'SimpleProduct') {
                //print(loginToken.cartId);
                runMutation({
                  'cartIdString': '${cart.cartId}',
                  'cartItemsMap': [
                    {'quantity': widget.quantity, 'sku': widget.parentSku}
                  ]
                });
              } else {
                runMutation({
                  'cartIdString': cart.cartId,
                  'cartItemsMap': [
                    {'quantity': widget.quantity, 'sku': widget.parentSku}
                  ]
                });
              }
            },
            child: result!.isLoading
                ? BuildLoadingWidget(color: getTextColor(statesController.value))
                : Stack(
                    children: [
                      Center(
                        child: Text(
                          widget.title,
                          style: AppStyles.getMediumTextStyle(fontSize: widget.width * 0.028 > 14 ? 14 : widget.width * 0.028),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: SvgPicture.asset(
                      //     widget.svg,
                      //     width: widget.width * 0.08 > 30 ? 30 : widget.width * 0.08,
                      //     color: getTextColor(statesController.value),
                      //     // color: statesController.value.contains(MaterialState.hovered) ? widget.buttonColor : widget.textColor,
                      //   ),
                      // )
                    ],
                  ),
          );
        });
  }

  Color getButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return AppColors.scaffoldColor;
    }
    return widget.buttonColor;
  }

  Color getTextColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return widget.buttonColor;
    }
    return widget.textColor;
  }
}
