import 'package:flutter/material.dart';
import 'package:m2/utilities/utilities.dart';

class TwoColoredTitle extends StatelessWidget {
  const TwoColoredTitle(
      {Key? key, required this.firstHead, this.secondHead, required this.firstHeadColor, required this.secondHeadColor, this.subtitle})
      : super(key: key);
  final String firstHead;
  final String? secondHead;
  final Color firstHeadColor;
  final Color secondHeadColor;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              text: "$firstHead ",
              style: AppStyles.getMediumTextStyle(fontSize: 25, color: firstHeadColor),
              children: [
                if (secondHead != null)
                  TextSpan(
                    text: secondHead,
                    style: AppStyles.getMediumTextStyle(fontSize: 25, color: secondHeadColor),
                  ),
              ],
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
