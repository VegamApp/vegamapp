import 'package:flutter/material.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/widgets/widgets.dart';

class SliderBlock extends StatefulWidget {
  const SliderBlock({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  State<SliderBlock> createState() => _SliderBlockState();
}

class _SliderBlockState extends State<SliderBlock> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.data['sliders'] == null || widget.data['sliders'].isEmpty) {
      return const SizedBox();
    }
    return AppResponsive(
      mobile: widget.data['mobile_status'] ? getChild(size) : const SizedBox(),
      tablet: widget.data['desktop_status'] ? getChild(size) : const SizedBox(),
      desktop: widget.data['desktop_status'] ? getChild(size) : const SizedBox(),
    );
  }

  Widget getChild(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: CarouselContainer(
        width: size.width,
        data: widget.data,
      ),
    );
  }
}
