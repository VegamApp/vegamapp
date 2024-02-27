import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2/utilities/utilities.dart' as utilities;

class CartAmountListing extends StatelessWidget {
  const CartAmountListing({super.key, required this.title, required this.money, this.mainAxisAlignment, this.currency});
  final String title;
  final String? currency;
  final double money;
  final WrapAlignment? mainAxisAlignment;
  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,##,##,##0.00", "en_IN");

    return Wrap(
      alignment: mainAxisAlignment ?? WrapAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            title,
            style: utilities.AppStyles.getRegularTextStyle(fontSize: 16, color: utilities.AppColors.fontColor),
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${currency ?? utilities.currency} ', style: TextStyle(fontSize: 16, color: utilities.AppColors.fontColor)),
              TextSpan(text: f.format(money), style: utilities.AppStyles.getRegularTextStyle(fontSize: 16, color: utilities.AppColors.fontColor))
            ],
          ),
        )
      ],
    );
  }
}
