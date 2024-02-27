import 'package:flutter/material.dart';
import 'package:m2/utilities/app_colors.dart';
import 'package:m2/utilities/app_style.dart';

class BuildErrorWidget extends StatelessWidget {
  const BuildErrorWidget({super.key, this.onRefresh, this.buttonColor, this.textColor, this.buttonTextColor, this.errorMsg});
  final Function()? onRefresh;
  final Color? buttonColor;
  final Color? textColor;
  final Color? buttonTextColor;
  final String? errorMsg;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              errorMsg ?? 'An error occured please try again.',
              style: AppStyles.getRegularTextStyle(fontSize: 14, color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                backgroundColor: buttonColor ?? AppColors.primaryColor,
              ),
              onPressed: onRefresh,
              child: Text('Try again', style: AppStyles.getRegularTextStyle(fontSize: 14, color: buttonColor ?? Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
