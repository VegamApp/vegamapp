import 'dart:convert';
import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m2/services/models/product_model.dart';
import 'package:m2/utilities/text_style.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';

class ProductVarientWidget extends StatefulWidget {
  const ProductVarientWidget({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  State<ProductVarientWidget> createState() => _ProductVarientWidgetState();
}

class _ProductVarientWidgetState extends State<ProductVarientWidget> {
  double quantity = 1;
  TextEditingController pinCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // log(jsonEncode(widget.productModel.toJson()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          addAutomaticKeepAlives: true,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.productModel.items![0].configurableOptions!.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) => widget.productModel.items![0].configurableOptions![index].attributeCode == 'color'
              ? buildColor(index)
              : buildVarient(widget.productModel.items![0].configurableOptions![index].label!, index),
          // : SizedBox(),
        ),
        const SizedBox(height: 20),
        Divider(height: 1, color: AppColors.dividerColor),
        const SizedBox(height: 20),
        buildQuantityChanger(),
        const SizedBox(height: 30),
        buildDelivery(size),
        const SizedBox(height: 20),
        Divider(height: 1, color: AppColors.dividerColor),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: BuildButtonSingle(
                typeName: "typeName",
                width: size.width,
                title: 'ADD TO CART',
                buttonColor: AppColors.buttonColor,
                textColor: Colors.white,
                svg: 'assets/svg/shopping-cart.svg',
                parentSku: 'parentSku',
                selectedSku: 'selectedSku',
                quantity: quantity,
              ),
            ),
            SizedBox(width: size.width * 0.05 > 20 ? 20 : size.width * 0.05),
            Expanded(
              child: BuildButtonSingle(
                typeName: "typeName",
                width: size.width,
                title: 'BUY NOW',
                buttonColor: AppColors.fontColor,
                textColor: Colors.white,
                svg: 'assets/svg/flash.svg',
                parentSku: 'parentSku',
                selectedSku: 'selectedSku',
                quantity: quantity,
              ),
            ),
          ],
        )
      ],
    );
  }

  SizedBox buildColor(int i) {
    return SizedBox(
      height: 40,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text('Color', style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText)),
          ),
          Expanded(
            child: ListView.separated(
              addAutomaticKeepAlives: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.productModel.items![0].configurableOptions![i].values!.length,
              separatorBuilder: (context, index) => const SizedBox(width: 5),
              itemBuilder: (context, index) => InkWell(
                borderRadius: BorderRadius.circular(40), radius: 40,
                onTap: () {
                  setState(() {});
                },
                // child: Text(
                //   widget.productModel.items![0].configurableOptions![i].values![index].label!,
                //   style: AppStyles.getRegularTextStyle(
                //     fontSize: 13,
                //     color: AppColors.evenFadedText,
                //   ),
                // ),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // border: Border.all(color: Colors.amber),
                  ),
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(
                      int.parse('ff${widget.productModel.items![0].configurableOptions![i].values![index].swatchData!.replaceAll('#', '')}',
                          radix: 16),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  SizedBox buildVarient(String title, int i) {
    return SizedBox(
      height: 25,
      child: Row(children: <Widget>[
        SizedBox(
            width: 100,
            child: Text(
              title,
              style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText),
            )),
        Expanded(
          child: ListView.separated(
            addAutomaticKeepAlives: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 5),
            itemCount: widget.productModel.items![0].configurableOptions![i].values!.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(() {});
              },
              child: Container(
                  padding:
                      // checkAvailable
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 10)
                  // : null
                  ,
                  decoration:
                      //  checkAvailable
                      BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                      color:
                          // selectedVarient![i] == widget.productModel.items![0].configurableOptions![i].values![index].label
                          // ?
                          // AppColors.buttonColor
                          // :
                          AppColors.evenFadedText,
                    ),
                  ),
                  // : null,
                  alignment: Alignment.center,
                  child:
                      //  currentVarient ==
                      // ?
                      Text(
                    widget.productModel.items![0].configurableOptions![i].values![index].label!,
                    style: AppStyles.getRegularTextStyle(
                      fontSize: 13,
                      color:
                          // widget.productModel.items![0].configurableOptions![i].values![index].label == selectedVarient![i]
                          //     ? AppColors.buttonColor
                          // :
                          AppColors.evenFadedText,
                    ),
                  )
                  // :
                  //     DottedBorder(
                  //   padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  //   color: AppColors.evenFadedText,
                  //   child: Text(
                  //     widget.productModel.items![0].configurableOptions![i].values![index].label!,
                  //     style: AppStyles.getRegularTextStyle(
                  //       fontSize: 13,
                  //       color: AppColors.evenFadedText,
                  //     ),
                  //   ),
                  // ),
                  ),
            ),
          ),
        )
      ]),
    );
  }

  Widget buildQuantityChanger() {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          SizedBox(
            width: 105,
            child: Text('Quantity', style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText)),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.evenFadedText),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
                  alignment: Alignment.center,
                  child: Text(
                    quantity.round().toString(),
                    style: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.evenFadedText),
                  ),
                ),
                VerticalDivider(color: AppColors.evenFadedText, width: 2),
                Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => quantity++),
                        child: SizedBox(
                          width: 30,
                          child: Center(child: Icon(Icons.expand_less, size: 17.5, color: AppColors.evenFadedText)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => quantity--),
                        child: SizedBox(
                          width: 30,
                          child: Center(child: Icon(Icons.expand_more, size: 17.5, color: AppColors.evenFadedText)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  SizedBox buildDelivery(Size size) {
    return SizedBox(
      height: 40,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: <Widget>[
          SizedBox(
              width: 100,
              child: Text(
                'Delivery',
                style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText),
              )),
          Container(
            width: size.width * 0.5,
            constraints: const BoxConstraints(maxWidth: 250),
            height: 25,
            child: TextFormField(
              controller: pinCode,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
              style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                isDense: true,
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.location_on_outlined, size: 15),
                ),
                hintText: 'Enter your pincode',
                hintStyle: AppStyles.getLightTextStyle(fontSize: 12, color: AppColors.fadedText),
                suffixIcon: InkWell(
                  onTap: () {},
                  child: Text(
                    'Check',
                    style: AppStyles.getRegularTextStyle(fontSize: 11, color: AppColors.fadedText),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
