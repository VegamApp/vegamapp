import 'package:flutter/material.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/scaffold_body.dart';

class OrderPlacedView extends StatefulWidget {
  const OrderPlacedView({super.key});
  static String route = 'ordersucess';
  @override
  State<OrderPlacedView> createState() => _OrderPlacedViewState();
}

class _OrderPlacedViewState extends State<OrderPlacedView> {
  @override
  Widget build(BuildContext context) {
    return BuildScaffold(
        child: ListView(
      shrinkWrap: true,
      children: [
        // const BuildCheckoutSteps(index: 3),
        const SizedBox(height: 20),
        ConstrainedBox(constraints: const BoxConstraints(maxHeight: 400), child: Image.asset('assets/images/thankyou.png')),
        const SizedBox(height: 20),
        Text(
          'Your order was successfully placed.\nPlease check your email for further instructions.',
          style: AppStyles.getMediumTextStyle(fontSize: 15, color: AppColors.fontColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Wrap(
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            Text(
              'Having trouble? ',
              style: AppStyles.getLightTextStyle(fontSize: 14, color: AppColors.fontColor),
            ),
            InkWell(
              onTap: () {},
              child: Text(
                'Contact us',
                style: AppStyles.getLightTextStyle(fontSize: 14, color: AppColors.buttonColor),
              ),
            )
          ],
        ),
      ],
    ));
  }
}
