import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/views/product_views/product_view.dart';

class ProductHorizontalListing extends StatefulWidget {
  const ProductHorizontalListing({super.key, required this.title, this.id, required this.children, this.gridSize, this.aspectRatio});
  final String title;
  final String? id;
  final List<Widget> children;
  final int? gridSize;
  final double? aspectRatio;
  @override
  State<ProductHorizontalListing> createState() => _ProductHorizontalListingState();
}

class _ProductHorizontalListingState extends State<ProductHorizontalListing> {
  final ScrollController _controller = ScrollController();
  bool atEdge = false;
  bool atBegining = true;

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

  late Widget leftArrow = InkWell(
    onTap: () => _controller.animateTo(_controller.position.minScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
    child: getContainer(Icons.chevron_left),
  );
  late Widget rightArrow = InkWell(
    onTap: () => _controller.animateTo(_controller.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
    child: getContainer(Icons.chevron_right),
  );

  Widget getArrows() {
    if (atBegining) {
      return Align(alignment: Alignment.centerRight, child: rightArrow);
    }
    if (atEdge) {
      return Align(alignment: Alignment.centerLeft, child: leftArrow);
    }
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leftArrow,
          rightArrow,
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
        Container(
          // height: 360,
          height: size.width * 0.85,
          constraints: const BoxConstraints(maxHeight: 400),
          // color: Colors.green,
          child: Stack(
            children: [
              ListView.separated(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                shrinkWrap: true,
                itemCount: widget.children.length + 1,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  if (index != widget.children.length) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: AppResponsive.isMobile(context) ? size.width * 0.4 : 400,
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: widget.children[index],
                    );
                  }
                  if (widget.id == null) {
                    return const SizedBox();
                  }
                  return InkWell(
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
                      width: size.width * 0.4,
                      // height: size.width * 0.8,
                      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 340),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        // boxShadow: [BoxShadow(color: AppColors.lightGrey, blurRadius: 6)],
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
              // Transform.translate(
              //   offset: Offset(0, 30),
              //   child: getArrows(),
              // )
              Center(child: getArrows()),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  getContainer(IconData icon) => Container(
        width: 25,
        height: 50,
        // margin: EdgeInsets.only(bottom: 200),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: icon == Icons.chevron_right ? const BorderRadius.horizontal(left: Radius.circular(5)) : const BorderRadius.horizontal(right: Radius.circular(5)),
        ),
        child: Center(child: Icon(icon, color: Colors.white)),
      );
}
