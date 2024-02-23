
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m2/services/models/product_model.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';

class ProductVarientWidget extends StatefulWidget {
  const ProductVarientWidget({super.key, required this.productModel, required this.onUpdated});
  final ProductModel productModel;
  final Function(List<Map<String, dynamic>>? newMedia) onUpdated;
  @override
  State<ProductVarientWidget> createState() => _ProductVarientWidgetState();
}

class _ProductVarientWidgetState extends State<ProductVarientWidget> {
  double quantity = 1;
  late String? selectedSku = widget.productModel.items![0].variants?[0].product?.sku;

  TextEditingController pinCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // log(jsonEncode(widget.productModel.toJson()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.productModel.items![0].configurableOptions != null)
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
        if (widget.productModel.items![0].configurableOptions != null) const SizedBox(height: 20),
        if (widget.productModel.items![0].configurableOptions != null) Divider(height: 1, color: AppColors.dividerColor),
        if (widget.productModel.items![0].configurableOptions != null) const SizedBox(height: 20),
        buildQuantityChanger(),
        const SizedBox(height: 30),
        // buildDelivery(size),
        // const SizedBox(height: 20),
        Divider(height: 1, color: AppColors.dividerColor),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: BuildButtonSingle(
                typeName: widget.productModel.items![0].sTypename!,
                parentSku: widget.productModel.items![0].sku!,
                selectedSku: selectedSku,
                width: size.width,
                title: 'ADD TO CART',
                buttonColor: AppColors.buttonColor,
                textColor: Colors.white,
                svg: 'assets/svg/shopping-cart.svg',
                quantity: quantity,
              ),
            ),
            SizedBox(width: size.width * 0.05 > 20 ? 20 : size.width * 0.05),
            Expanded(
              child: BuildButtonSingle(
                typeName: widget.productModel.items![0].sTypename!,
                width: size.width,
                title: 'BUY NOW',
                buttonColor: AppColors.fontColor,
                textColor: Colors.white,
                svg: 'assets/svg/flash.svg',
                parentSku: widget.productModel.items![0].sku!,
                selectedSku: selectedSku,
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
                  // print(jsonEncode(widget.productModel.items![0].configurableOptions![i].toJson()));
                  print(widget.productModel.items![0].configurableOptions![i].values![index].swatchData);
                  setState(() => varientData[i] = widget.productModel.items![0].configurableOptions![i].values![index].uid!);

                  setSku();
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
                  width: 33,
                  height: 33,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: varientData.contains(widget.productModel.items![0].configurableOptions![i].values![index].uid)
                          ? Border.all(color: AppColors.kPrimaryColor, width: 3)
                          : null,
                      boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 5, offset: const Offset(0, 3))]),
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(
                      int.parse('ff${widget.productModel.items![0].configurableOptions![i].values![index].swatchData!.replaceAll('#', '')}', radix: 16),
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
          ),
        ),
        Expanded(
          child: ListView.separated(
            addAutomaticKeepAlives: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 5),
            itemCount: widget.productModel.items![0].configurableOptions![i].values!.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(() => varientData[i] = widget.productModel.items![0].configurableOptions![i].values![index].uid!);

                setSku();

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
                    border: varientData.contains(widget.productModel.items![0].configurableOptions![i].values![index].uid)
                        ? Border.all(
                            width: 2.0,
                            color: AppColors.buttonColor,
                          )
                        : Border.all(
                            width: 1.0,
                            color: AppColors.evenFadedText,
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

  late List<String> varientData =
      List.generate(widget.productModel.items![0].configurableOptions!.length, (index) => widget.productModel.items![0].configurableOptions![index].values![0].uid!);

  setSku() {
    if (varientData.contains(null)) return;
    // print(jsonEncode(widget.productModel.items![0].variants!.map((e) => e.toJson()).toList()));
    // List<Map<String, dynamic>> varients = List<Map<String, dynamic>>.from(productData['variants']);
    //
    print(varientData);
    for (var element in widget.productModel.items![0].variants!) {
      bool broken = false;
      for (int i = 0; i < varientData.length; i++) {
        if (!varientData.contains(element.attributes![i].uid)) {
          broken = true;
          break;
        }
      }
      if (broken) {
        print("broken");
        continue;
      }
      print("Not broken");
      selectedSku = element.product!.sku;
      List<Map<String, dynamic>>? mediaGallery =
          element.product!.mediaGallery != null && element.product!.mediaGallery!.isNotEmpty ? List<Map<String, dynamic>>.from(element.product!.mediaGallery!) : null;
      widget.onUpdated(mediaGallery);
      // productData['media_gallery'] =
      //     element['product']['media_gallery'] != null && element['product']['media_gallery'].isNotEmpty ? element['product']['media_gallery'] : productData['media_gallery'];
      // productData['special_price'] = element['product']['special_price'];
      // productData['price_range'] = element['product']['price_range'];
      setState(() {});
    }
  }

  Widget buildQuantityChanger() {
    return SizedBox(
      height: 45,
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
                  width: 60,
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
                          width: 50,
                          height: 40,
                          child: Center(child: Icon(Icons.expand_less, size: 17.5, color: AppColors.evenFadedText)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() {
                          if (quantity > 1) quantity--;
                        }),
                        child: SizedBox(
                          width: 50,
                          height: 40,
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
