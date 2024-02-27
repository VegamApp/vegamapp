import 'package:flutter/material.dart';

import '../utilities.dart';

// show stamps in the footbar
class StampContainer extends StatelessWidget {
  const StampContainer({super.key, required this.width});
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 20),
      // height: 200,
      color: AppColors.containerColor,
      // decoration: BoxDecoration(
      //   color: AppColors.containerColor,
      //   image: const DecorationImage(
      //     image: AssetImage('assets/images/stamp.png'),
      //   ),
      // ),
      child: Center(
        child: Image.asset('assets/images/stamp.png'),
      ),
    );
  }
}
