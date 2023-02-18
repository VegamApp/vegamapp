import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' show CarouselController, CarouselOptions, CarouselSlider;
import 'package:flutter/material.dart';
import 'package:m2/utilities/utilities.dart';

class BuildCarousel extends StatefulWidget {
  const BuildCarousel({Key? key, required this.images, this.autoplay = true, required this.aspectRatio, this.clipEdge = false}) : super(key: key);
  final bool clipEdge;
  final List<Map<String, dynamic>> images;
  final bool autoplay;
  final double aspectRatio;
  @override
  State<BuildCarousel> createState() => _BuildCarouselState();
}

class _BuildCarouselState extends State<BuildCarousel> {
  final CarouselController _controller = CarouselController();
  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (int i = 0; i < widget.images.length; i++) {
      precacheImage(CachedNetworkImageProvider(widget.images[i]['image'] ?? widget.images[i]['slider_image']), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      // height: size.width / widget.aspectRatio,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            // height: size.width / widget.aspectRatio,
            width: size.width,
            child: ClipRRect(
              borderRadius: widget.clipEdge ? BorderRadius.circular(size.width * 0.025) : BorderRadius.zero,
              child: CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  scrollPhysics: widget.images.length == 1 ? const NeverScrollableScrollPhysics() : null,
                  autoPlay: widget.images.length == 1 ? false : widget.autoplay,
                  aspectRatio: widget.aspectRatio,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) => setState(() => currentIndex = index),
                ),
                items: widget.images.map((e) {
                  return InkWell(
                    onTap: () => navigateToPages(context, e['link']),
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: e['image'] ?? e['slider_image'],
                      progressIndicatorBuilder: (context, string, progress) => Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                          value: progress.progress,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          if (widget.images.length != 1) const SizedBox(height: 10),
          if (widget.images.length != 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => InkWell(
                  onTap: () => _controller.animateToPage(index),
                  child: Container(
                    height: 5,
                    width: 5,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: index == currentIndex ? AppColors.primaryColor : AppColors.evenFadedText,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  navigateToPages(BuildContext context, var link) {
    print(link);
    // if (link['category_id'] != null) {
    //   return navigate(context, ProductListingPage.route, arguments: {'catergoryId': link['category_id']});
    // }
    // if (link['product_id'] != null) {
    //   navigate(context, ProductDetails.route, arguments: link['product_id']);
    // }
    // if (link['']) {}
    // if (link['']) {}
  }
}
