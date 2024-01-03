import 'package:flutter/material.dart';
import 'package:m2/utilities/utilities.dart';

class TwoColoredTitle extends StatelessWidget {
  const TwoColoredTitle({Key? key, required this.title, required this.firstHeadColor, required this.secondHeadColor, this.subtitle}) : super(key: key);
  final String title;

  final Color firstHeadColor;
  final Color secondHeadColor;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    List<String> texts = title.split(" ");
    String first = texts.removeAt(0);
    print(texts);
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              text: "$first ",
              style: AppStyles.getMediumTextStyle(fontSize: 25, color: firstHeadColor),
              children: texts
                  .map(
                    (e) => TextSpan(
                      text: e,
                      style: AppStyles.getMediumTextStyle(fontSize: 25, color: secondHeadColor),
                    ),
                  )
                  .toList(),
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
