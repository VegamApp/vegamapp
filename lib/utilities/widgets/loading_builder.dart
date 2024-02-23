import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:shimmer/shimmer.dart';

class BuildLoadingWidget extends StatelessWidget {
  const BuildLoadingWidget({
    super.key,
    this.color,
    this.size,
  });
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(height: size ?? 20, width: size ?? 20, child: CircularProgressIndicator(color: color)));
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.width, this.height, this.color});
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

class ProductLoadingLister extends StatelessWidget {
  const ProductLoadingLister({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: isLoading,
        child: GridView.builder(
          // padding: const EdgeInsets.all(20),
          itemCount: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: constraints.maxWidth < 500
              ? SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // crossAxisCount: constraints.maxWidth < 600 ? 2 : (constraints.maxWidth / 280).floor(),
                  crossAxisSpacing: constraints.maxWidth < 800 ? 10 : 40,
                  mainAxisSpacing: constraints.maxWidth < 800 ? 10 : 40,
                  mainAxisExtent: constraints.maxWidth * 0.8
                  // height: getGridViewHeight(constraints.maxWidth),
                  )
              : SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  // crossAxisCount: constraints.maxWidth < 600 ? 2 : (constraints.maxWidth / 280).floor(),
                  crossAxisSpacing: constraints.maxWidth < 800 ? 10 : 40,
                  mainAxisSpacing: constraints.maxWidth < 800 ? 10 : 40,
                  mainAxisExtent: 400
                  // height: getGridViewHeight(constraints.maxWidth),
                  ),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(15),
              constraints: const BoxConstraints(maxHeight: 400),
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: AppColors.evenFadedText, blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  const SizedBox(height: 5),
                  Container(height: 20),
                  const SizedBox(height: 5),
                  Container(height: 20),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 20,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
