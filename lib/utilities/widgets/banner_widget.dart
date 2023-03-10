import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/views/product_views/product_view.dart';

class BannerBlock extends StatelessWidget {
  const BannerBlock({Key? key, required this.data}) : super(key: key);
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppResponsive(
      mobile: data['mobile_status'] ? getChild(size, context) : const SizedBox(),
      tablet: data['status'] ? getChild(size, context) : const SizedBox(),
      desktop: data['status'] ? getChild(size, context) : const SizedBox(),
    );
  }

  Widget getChild(Size size, BuildContext context) {
    return SizedBox(
      height: size.width * 0.5,
      child: Row(
        children: List.generate(
          data['banneritems'].length,
          (index) => Expanded(
            child: InkWell(
              onTap: () {
                // //print(data['banneritems'][index]);
                try {
                  switch (data['banneritems'][index]['link_info']['link_type']) {
                    case 'category':
                      if (data['banneritems'][index]['link_info']['category_id'] != null) {
                        context.go('/${ProductView.route}?categoryId=${data['banneritems'][index]['link_info']['category_id']}');
                        // navigate(context, ProductView.route, arguments: {"categoryId": data['banneritems'][index]['link_info']['category_id']});
                      }
                      break;
                    case 'product':
                      if (data['banneritems'][index]['link_info']['product_sku'] != null) {
                        context.go('/${ProductView.route}/${data['banneritems'][index]['link_info']['product_sku']}');

                        // navigate(context, ProductView.route,(sku: data['banneritems'][index]['link_info']['product_sku']));
                      }
                      break;
                    default:
                      break;
                  }
                } catch (e) {
                  //print(e);
                }
              },
              child: Container(
                // width: constraints.maxWidth * data['banneritems'][index]['layout'],
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(data['banneritems'][index]['image']),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
