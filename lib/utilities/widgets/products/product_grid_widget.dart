import 'package:flutter/material.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/sliver_grid_with_fixed_height.dart';
import 'package:m2/utilities/utilities.dart';

class ProductGridWidget extends StatefulWidget {
  const ProductGridWidget({super.key, required this.title, this.id, required this.children, this.gridSize, this.aspectRatio});
  final String title;
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
      return Column(
        children: [
          Text(
            widget.title,
            style: AppStyles.getBoldTextStyle(
              fontSize: 22,
              color: const Color(0xff000000),
            ),
            textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          GridView.builder(
            // padding: const EdgeInsets.all(20),
            itemCount: widget.children.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
              crossAxisCount: constraints.maxWidth < 600 ? 2 : (constraints.maxWidth / 250).floor(),
              crossAxisSpacing: constraints.maxWidth < 800 ? 10 : 30,
              mainAxisSpacing: constraints.maxWidth < 800 ? 10 : 30,
              height: 400,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: AppResponsive.isMobile(context) ? constraints.maxWidth * 0.4 : 240,
                constraints: const BoxConstraints(maxWidth: 280),
                child: widget.children[index],
              );
            },
          ),
        ],
      );
    });
  }
}
