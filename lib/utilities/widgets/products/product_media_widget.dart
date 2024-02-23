import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart ';
import 'package:m2/utilities/utilities.dart';

class ProductMediaContainer extends StatefulWidget {
  const ProductMediaContainer({super.key, required this.width, required this.data});
  final double width;
  final List<Map<String, dynamic>> data;
  @override
  State<ProductMediaContainer> createState() => ProductMediaContainerState();
}

class ProductMediaContainerState extends State<ProductMediaContainer> {
  static late Widget _currentDisplayWidget;
  static refreshCurrentDisplayWidget(String child) {
    _currentDisplayWidget = CachedNetworkImage(
      key: const ValueKey<int>(0),
      imageUrl: child,
    );
  }

  @override
  void initState() {
    super.initState();
    refreshCurrentDisplayWidget(widget.data[0]['url']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.width * 0.9,
      // height: 350,
      padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(maxHeight: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: SizedBox(
              width: 70,
              child: ListView.separated(
                addAutomaticKeepAlives: true,
                // padding: EdgeInsets.symmetric(vertical: widget.width * 0.05 > 10 ? 10 : widget.width * 0.05),
                itemCount: widget.data.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _currentDisplayWidget = CachedNetworkImage(key: ValueKey<int>(index), imageUrl: widget.data[index]['url']);
                      });
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      // padding: EdgeInsets.all(widget.width * 0.0125 > 5 ? 5 : widget.width * 0.0125),
                      decoration: BoxDecoration(
                        // color: Colors.amber,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(width: 1.0, color: const Color(0x47c5c5c5)),
                      ),
                      child: CachedNetworkImage(imageUrl: widget.data[index]['url']),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _currentDisplayWidget,
            ),
          )
        ],
      ),
    );
  }
}
