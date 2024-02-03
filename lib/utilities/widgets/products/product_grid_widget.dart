import 'package:flutter/material.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/two_colored_title.dart';

class ProductGridWidget extends StatefulWidget {
  const ProductGridWidget({super.key, this.title, this.id, required this.children, this.gridSize, this.aspectRatio});
  final String? title;
  final String? id;
  final List<Widget> children;
  final int? gridSize;
  final double? aspectRatio;
  @override
  State<ProductGridWidget> createState() => _ProductGridWidgetState();
}

class _ProductGridWidgetState extends State<ProductGridWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 1400 ? (constraints.maxWidth - 1400) / 2 : 20, vertical: 20),
        child: Column(
          children: [
            if (widget.title != null) TwoColoredTitle(title: widget.title!, firstHeadColor: AppColors.primaryColor, secondHeadColor: AppColors.fadedText),
            if (widget.title != null) const SizedBox(height: 10),
            GridView.builder(
              // padding: const EdgeInsets.all(20),
              itemCount: widget.children.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: constraints.maxWidth < 500 ? 200 : 400,
                // crossAxisCount: constraints.maxWidth < 600 ? 2 : (constraints.maxWidth / 250).floor(),
                crossAxisSpacing: constraints.maxWidth < 500 ? 10 : 30,
                mainAxisSpacing: constraints.maxWidth < 500 ? 10 : 30,
                mainAxisExtent: 400,
              ),
              itemBuilder: (context, index) {
                return Container(
                  // padding: const EdgeInsets.symmetric(vertical: 10),
                  width: AppResponsive.isMobile(context) ? constraints.maxWidth * 0.4 : 240,
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: widget.children[index],
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
