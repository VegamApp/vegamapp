import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/app_colors.dart';
import 'package:m2/utilities/text_style.dart';
import 'package:m2/utilities/widgets/two_colored_title.dart';
import 'package:m2/views/product_views/product_view.dart';

class BannerBlock extends StatefulWidget {
  const BannerBlock({super.key, required this.backimage, this.maintext, this.moreimage, this.color, required this.data, this.title});
  final List<Map<String, dynamic>> backimage;
  final String? maintext;
  final String? moreimage;
  final Color? color;
  final Map data;
  final String? title;
  @override
  State<BannerBlock> createState() => _BannerBlockState();
}

class _BannerBlockState extends State<BannerBlock> {
  Color? textColor;
  // getImageColor(String url) async {
  //   imageP.Image image = imageP.decodeImage((await _fileFromImageUrl(url)).readAsBytesSync())!;
  //   var data = image.getBytes();
  //   var colorSum = 0;
  //   for (var x = 0; x < data.length; x += 4) {
  //     int r = data[x];
  //     int g = data[x + 1];
  //     int b = data[x + 2];
  //     int avg = ((r + g + b) / 3).floor();
  //     colorSum += avg;
  //   }
  //   var brightness = (colorSum / (image.width * image.height)).floor();
  //   return brightness;
  // }

  // Future<File> _fileFromImageUrl(String url) async {
  //   final response = await http.get(Uri.parse(url));

  //   File file = File('/imagetest.png');

  //   file.writeAsBytesSync(response.bodyBytes);

  //   return file;
  // }

  @override
  void initState() {
    super.initState();
    // getImageColor(widget.backimage);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            if (widget.title != null) const SizedBox(height: 20),
            if (widget.title != null) TwoColoredTitle(title: widget.title!, firstHeadColor: AppColors.primaryColor, secondHeadColor: Colors.black),
            Container(
              // height: 130,
              // margin: const EdgeInsets.only(top: 13),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                // image: DecorationImage(image: CachedNetworkImageProvider(widget.backimage), fit: BoxFit.contain),
              ),
              child: AppResponsive(
                mobile: Column(
                  children: widget.backimage
                      .map((e) => InkWell(
                            onTap: () {
                              String path = '';
                              if (e['link_info']['category_id'] != null) {
                                path = 'categoryId=${e['link_info']['category_id']}';
                              }
                              context.push('/${ProductView.route}?$path');
                            },
                            child: IntrinsicHeight(
                              child: Stack(
                                children: [
                                  CachedNetworkImage(imageUrl: e['image']),
                                  if (widget.maintext != null)
                                    Center(child: Text(e['title'], textAlign: TextAlign.center, style: AppStyles.getMediumTextStyle(fontSize: 14, color: widget.color))),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
                desktop: Row(
                  children: widget.backimage
                      .map((e) => InkWell(
                            onTap: () {
                              print(e);
                              String path = '';
                              if (e['link_info']['category_id'] != null) {
                                path = 'categoryId=${e['link_info']['category_id']}';
                              }
                              context.push('/${ProductView.route}?$path');
                            },
                            child: SizedBox(
                              width: e['layout'] != null ? (MediaQuery.sizeOf(context).width / 12) * double.parse(e['layout']) : MediaQuery.sizeOf(context).width,
                              child: IntrinsicHeight(
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(imageUrl: e['image']),
                                    if (widget.maintext != null)
                                      Center(child: Text(e['title'], textAlign: TextAlign.center, style: AppStyles.getMediumTextStyle(fontSize: 14, color: widget.color))),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
        // Align(
        //   alignment: Alignment.topCenter,
        //   child: Container(
        //     height: 50,
        //     width: 150,
        //     decoration: const BoxDecoration(
        //       image: DecorationImage(image: AssetImage("assets/images/more1.png"), fit: BoxFit.cover),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
