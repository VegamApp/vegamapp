import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/scroll_behavoir.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/product_views/product_view.dart';

class ProductHorizontalListing extends StatefulWidget {
  const ProductHorizontalListing({super.key, this.title, this.id, required this.children, this.gridSize, this.aspectRatio, this.padding});
  final String? title;
  final String? id;
  final List<Widget> children;
  final int? gridSize;
  final double? aspectRatio;
  final EdgeInsets? padding;
  @override
  State<ProductHorizontalListing> createState() => _ProductHorizontalListingState();
}

class _ProductHorizontalListingState extends State<ProductHorizontalListing> {
  final ScrollController _controller = ScrollController();
  bool atEdge = false;
  bool atBegining = true;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == 0) {
        atBegining = true;
        atEdge = false;
        setState(() {});
      } else if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        atBegining = false;
        atEdge = true;
        setState(() {});
      } else {
        atBegining = false;
        atEdge = false;
        setState(() {});
      }
    });
  }

  Widget leftArrow({BoxConstraints? constraints}) => InkWell(
        onTap: () => _controller.animateTo(_controller.position.minScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
        child: getContainer(Icons.chevron_left, atBegining ? AppColors.evenFadedText : AppColors.primaryColor, constraints),
      );
  Widget rightArrow({BoxConstraints? constraints}) => InkWell(
        onTap: () => _controller.animateTo(_controller.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
        child: getContainer(Icons.chevron_right, atEdge ? AppColors.evenFadedText : AppColors.primaryColor, constraints),
      );

  Widget getArrows() {
    if (atBegining) {
      return Align(alignment: Alignment.centerRight, child: rightArrow());
    }
    if (atEdge) {
      return Align(alignment: Alignment.centerLeft, child: leftArrow());
    }
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leftArrow(),
          rightArrow(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Text(
        //   widget.title,
        //   style: AppStyles.getBoldTextStyle(
        //     fontSize: 22,
        //     color: const Color(0xff000000),
        //   ),
        //   textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
        //   textAlign: TextAlign.center,
        // ),
        if (widget.title != null) TwoColoredTitle(title: widget.title!, firstHeadColor: AppColors.kPrimaryColor, secondHeadColor: Colors.black),
        // const SizedBox(height: 10),
        Container(
          // height: 360,
          height: size.width * 0.85,
          constraints: const BoxConstraints(maxHeight: 380),
          // color: Colors.green,
          child: LayoutBuilder(builder: (context, totalConstraints) {
            return Stack(
              children: [
                Row(
                  children: [
                    if (totalConstraints.maxWidth >= 720) leftArrow(constraints: totalConstraints),
                    Expanded(
                      child: LayoutBuilder(builder: (context, constraints) {
                        return ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            controller: _controller,
                            shrinkWrap: true,
                            itemCount: widget.children.length + 1,
                            scrollDirection: Axis.horizontal,
                            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 20),
                            separatorBuilder: (context, index) => SizedBox(width: AppResponsive.isMobile(context) ? 10 : 20),
                            itemBuilder: (context, index) {
                              if (index != widget.children.length) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  width: constraints.maxWidth < 720
                                      ? constraints.maxWidth * 0.4
                                      : constraints.maxWidth > 1000
                                          ? (constraints.maxWidth - 100) / 4
                                          : (constraints.maxWidth - 80) / 3,
                                  // constraints: const BoxConstraints(maxWidth: 400),
                                  child: widget.children[index],
                                );
                              }
                              if (widget.id == null) {
                                return const SizedBox();
                              }
                              return InkWell(
                                onHover: (value) => setState(() => _isHovered = value),
                                onTap: () {
                                  //print(widget.id);
                                  context.go("/${ProductView.route}?viewAll=true&categoryId=${widget.id}");
                                  // navigate(context, ProductView.route, arguments: {
                                  //   'viewAll': true,
                                  //   'id': widget.id,
                                  //   'title': widget.title,
                                  // });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  width: constraints.maxWidth < 720
                                      ? constraints.maxWidth * 0.4
                                      : constraints.maxWidth > 1000
                                          ? (constraints.maxWidth - 100) / 4
                                          : (constraints.maxWidth - 80) / 3,
                                  constraints: const BoxConstraints(maxHeight: 340),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: AppResponsive.isMobile(context)
                                        ? [BoxShadow(color: AppColors.evenFadedText, blurRadius: 5)]
                                        : !_isHovered
                                            ? null
                                            : [BoxShadow(color: AppColors.evenFadedText, blurRadius: 5)],
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("View All", style: AppStyles.getSemiBoldTextStyle(fontSize: 16, color: AppColors.primaryColor)),
                                      const SizedBox(width: 5),
                                      Icon(Icons.arrow_forward, color: AppColors.primaryColor, size: 20),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                    if (totalConstraints.maxWidth >= 720) rightArrow(constraints: totalConstraints),
                  ],
                ),
                // Transform.translate(
                //   offset: Offset(0, 30),
                //   child: getArrows(),
                // )
                if (totalConstraints.maxWidth < 720) Center(child: getArrows()),
              ],
            );
          }),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  getContainer(IconData icon, Color color, BoxConstraints? totalConstraints) => Container(
        width: totalConstraints != null && totalConstraints.maxWidth > 720 ? 50 : 25,
        height: 50,
        // margin: EdgeInsets.only(bottom: 200),
        decoration: BoxDecoration(
          color: color,
          shape: totalConstraints != null && totalConstraints.maxWidth > 720 ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: totalConstraints != null && totalConstraints.maxWidth > 720
              ? null
              : icon == Icons.chevron_right
                  ? const BorderRadius.horizontal(left: Radius.circular(5))
                  : const BorderRadius.horizontal(right: Radius.circular(5)),
        ),
        child: Center(child: Icon(icon, color: Colors.white)),
      );
}
