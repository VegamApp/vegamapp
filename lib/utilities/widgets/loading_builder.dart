import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m2/utilities/utilities.dart';

class BuildLoadingWidget extends StatelessWidget {
  const BuildLoadingWidget({
    Key? key,
    this.color,
    this.size,
  }) : super(key: key);
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(height: size ?? 20, width: size ?? 20, child: CircularProgressIndicator(color: color)));
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.width, this.height, this.color}) : super(key: key);
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 100,
      height: height ?? 20,
      child: SpinKitThreeBounce(color: color ?? AppColors.primaryColor),
    );
  }
}
