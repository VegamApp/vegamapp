import 'package:flutter/material.dart';
import 'package:m2/utilities/utilities.dart';

class TwoColoredTitle extends StatelessWidget {
  const TwoColoredTitle({super.key, required this.title, required this.firstHeadColor, required this.secondHeadColor, this.subtitle});
  final String title;

  final Color firstHeadColor;
  final Color secondHeadColor;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    List<String> texts = title.split(" ");
    String first = texts.removeAt(0);
    return Column(
      children: [
        Text.rich(
          TextSpan(
              text: "$first ",
              style: AppStyles.getMediumTextStyle(fontSize: 25, color: firstHeadColor),
              children: List.generate(
                texts.length,
                (index) => TextSpan(
                  text: '${texts[index]} ',
                  style: AppStyles.getMediumTextStyle(fontSize: 25, color: index % 2 == 0 ? secondHeadColor : firstHeadColor),
                ),
              )),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
