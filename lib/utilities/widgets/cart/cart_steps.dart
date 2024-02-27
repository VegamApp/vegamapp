import 'package:flutter/material.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/utilities.dart';

class BuildCartSteps extends StatelessWidget {
  const BuildCartSteps({super.key, required this.currentCartIndex, this.steps = const ['Shopping Cart', 'Address', 'Payment']});
  final int currentCartIndex;
  final List<String> steps;

  List<Widget> getChildren(List<String> steps, BuildContext context) {
    return List.generate(
        3,
        (listIndex) => InkWell(
              onTap: () {
                // print(currentCartIndex);
                // print(listIndex);
                if (currentCartIndex > listIndex) {
                  // print('hi');
                  for (int i = currentCartIndex; i > listIndex; i--) {
                    // print(i);
                    Navigator.pop(context);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: currentCartIndex > listIndex ? Colors.green : AppColors.evenFadedText,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          steps[listIndex],
                          style: AppStyles.getMediumTextStyle(
                            fontSize: 14,
                            color: currentCartIndex > listIndex ? AppColors.fontColor : AppColors.evenFadedText,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return AppResponsive(
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getChildren(steps, context),
        ),
        desktop: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.spaceBetween,
          children: getChildren(steps, context),
        ));
  }
}
