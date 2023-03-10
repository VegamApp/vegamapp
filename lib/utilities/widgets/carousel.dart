import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' show CarouselController, CarouselOptions, CarouselSlider;
import 'package:flutter/material.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/utilities.dart';

class CarouselContainer extends StatefulWidget {
  const CarouselContainer({
    Key? key,
    required this.width,
    required this.data,
    this.padding,
  }) : super(key: key);
  final double width;
  final Map<String, dynamic> data;
  final EdgeInsetsGeometry? padding;
  @override
  State<CarouselContainer> createState() => _CarouselContainerState();
}

class _CarouselContainerState extends State<CarouselContainer> {
  int currentIndex = 0;
  final CarouselController _controller = CarouselController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: widget.width,
      // padding: widget.padding ?? const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 30,
            offset: const Offset(0, 3),
          )
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: CarouselSlider(
        carouselController: _controller,
        items: List.generate(
            widget.data['sliders'].length,
            (index) => InkWell(
                  onTap: () {
                    //print(widget.data['sliders'][index]);
                    switch (widget.data['sliders'][index]['link']['link_type']) {
                      case 'product':
                        if (widget.data['sliders'][index]['link']['product_sku'] != null) {
                          // navigate(context, ProductDetail(sku: widget.data['sliders'][index]['link']['product_sku']));
                        }
                        break;
                      case 'category':
                        if (widget.data['sliders'][index]['link']['category_id'] != null) {
                          // navigate(context, ProductListing(catergoryId: widget.data['sliders'][index]['link']['category_id']));
                        }
                        break;
                      default:
                        break;
                    }
                  },
                  child: SizedBox(
                      height: AppResponsive.isMobile(context) ? size.width : 450,
                      child: CachedNetworkImage(imageUrl: widget.data['sliders'][index]['slider_image'], fit: BoxFit.contain)),
                )),
        options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            viewportFraction: 1,
            autoPlay: widget.data['autoplay'],
            height: AppResponsive.isMobile(context) ? size.width : 400,
            onPageChanged: (index, reason) {
              currentIndex = index;
              setState(() {});
            }),
      ),
    );
  }
}
