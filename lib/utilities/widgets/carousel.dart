import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' show CarouselController, CarouselOptions, CarouselSlider;
import 'package:flutter/material.dart';
import 'package:m2/services/state_management/home/home_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:provider/provider.dart';

class CarouselContainer extends StatefulWidget {
  const CarouselContainer({
    super.key,
    required this.width,
    required this.data,
    this.padding,
  });
  final double width;
  final Map<String, dynamic> data;
  final EdgeInsetsGeometry? padding;
  @override
  State<CarouselContainer> createState() => _CarouselContainerState();
}

class _CarouselContainerState extends State<CarouselContainer> {
  int currentIndex = 0;
  final CarouselController _controller = CarouselController();
  late HomeData homeData;

  getAspectRatio() async {
    Image image = Image.network(widget.data['sliders'][0]['slider_image']);
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));
    var data = await completer.future;
    double aspectRatio = data.width / data.height;

    homeData.putAspectRatio(aspectRatio);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    homeData = Provider.of<HomeData>(context);
    getAspectRatio();
    super.didChangeDependencies();
    if (widget.data['sliders'] != null) {
      for (int index = 0; index < widget.data['sliders'].length; index++) {
        precacheImage(CachedNetworkImageProvider(widget.data['sliders'][index]['slider_image']), context);
      }
    }
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
              switch (widget.data['sliders'][index]['link_info']['link_type']) {
                case 'product':
                  if (widget.data['sliders'][index]['link_info']['product_sku'] != null) {
                    // navigate(context, ProductDetail(sku: widget.data['sliders'][index]['link']['product_sku']));
                  }
                  break;
                case 'category':
                  if (widget.data['sliders'][index]['link_info']['category_id'] != null) {
                    // navigate(context, ProductListing(catergoryId: widget.data['sliders'][index]['link']['category_id']));
                  }
                  break;
                default:
                  break;
              }
            },
            child: SizedBox(
                // height: AppResponsive.isMobile(context) ? size.width : 450,
                child: CachedNetworkImage(imageUrl: widget.data['sliders'][index]['slider_image'], fit: BoxFit.contain)),
          ),
        ),
        options: CarouselOptions(
          scrollDirection: Axis.horizontal,
          viewportFraction: 1,
          autoPlay: widget.data['autoplay'] ?? true,
          aspectRatio: homeData.homeCarouselAspectRatio,
          onPageChanged: (index, reason) {
            currentIndex = index;
            setState(() {});
          },
        ),
      ),
    );
  }
}
