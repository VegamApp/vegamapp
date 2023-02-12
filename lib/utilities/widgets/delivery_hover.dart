import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:m2/utilities/utilities.dart';

class DeliveryHoverWidget extends StatefulWidget {
  const DeliveryHoverWidget({super.key});

  @override
  State<DeliveryHoverWidget> createState() => _DeliveryHoverWidgetState();
}

class _DeliveryHoverWidgetState extends State<DeliveryHoverWidget> {
  bool deliveryHover = false;
  bool showChild = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.275 > 200 ? 200 : size.width * 0.275,
      height: size.height > 100 ? 100 : size.height,
      constraints: const BoxConstraints(maxHeight: 140),
      // decoration: BoxDecoration(color: Colors.green),
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              // Show delivery check box
              onTap: () {
                setState((() => deliveryHover = !deliveryHover));
                if (showChild) {
                  setState((() => showChild = false));
                } else {
                  Timer(const Duration(milliseconds: 100), () {
                    setState(() {
                      showChild = !showChild;
                    });
                  });
                }
              },
              child: DottedBorder(
                color: AppColors.buttonColor,
                child: PopupMenuButton(
                  tooltip: "Check delivery",
                  position: PopupMenuPosition.under,
                  offset: const Offset(-10, 15),
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Available',
                          style: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.buttonColor),
                        ),
                        SvgPicture.asset('assets/svg/location_on.svg', height: 20, color: AppColors.buttonColor),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: false,
                      padding: EdgeInsets.zero,
                      onTap: null,
                      height: 90,
                      child: Center(
                        child: SizedBox(
                          height: 90,
                          width: 150,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Text('Locate Automatically', style: AppStyles.getRegularTextStyle(fontSize: 12, color: AppColors.fadedText)),
                              ),
                              const SizedBox(height: 5),
                              Text('OR', style: AppStyles.getBoldTextStyle(fontSize: 11, color: AppColors.primaryColor)),
                              const SizedBox(height: 5),
                              Expanded(
                                child: TextFormField(
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                      border: const OutlineInputBorder(),
                                      hintStyle: AppStyles.getRegularTextStyle(fontSize: 12, color: AppColors.fadedText),
                                      hintText: 'Enter PinCode',
                                      alignLabelWithHint: true,
                                      floatingLabelAlignment: FloatingLabelAlignment.center),
                                  style: AppStyles.getRegularTextStyle(fontSize: 12, color: AppColors.fadedText),
                                  textAlign: TextAlign.center,
                                  //TODO: Pincode
                                  onFieldSubmitted: null,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 6),
            // AnimatedContainer(
            //   duration: const Duration(milliseconds: 100),
            //   height: deliveryHover ? 80 : 0,
            //   width: 200,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: AppColors.buttonColor, width: 1),
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            //   padding: const EdgeInsets.all(5),
            //   child: showChild
            //       ? Column(
            //           children: [
            //             InkWell(
            //                 onTap: () {},
            //                 child: Text('Locate Automatically', style: AppStyles.getRegularTextStyle(fontSize: 12, color: AppColors.fadedText))),
            //             Text('OR', style: AppStyles.getBoldTextStyle(fontSize: 11, color: AppColors.primaryColor)),
            //             Expanded(
            //               child: TextFormField(
            //                 decoration: InputDecoration(
            //                     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            //                     border: const OutlineInputBorder(),
            //                     hintStyle: AppStyles.getRegularTextStyle(fontSize: 11, color: AppColors.evenFadedText),
            //                     hintText: 'Enter PinCode',
            //                     alignLabelWithHint: true,
            //                     floatingLabelAlignment: FloatingLabelAlignment.center),
            //                 style: AppStyles.getRegularTextStyle(fontSize: 11, color: AppColors.evenFadedText),
            //                 textAlign: TextAlign.center,
            //               ),
            //             )
            //           ],
            //         )
            //       : null,
            // )
          ],
        );
      }),
    );
  }
}
