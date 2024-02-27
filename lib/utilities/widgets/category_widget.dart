import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/utilities.dart';

class CatergoryWidget extends StatelessWidget {
  const CatergoryWidget({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return AppResponsive(
      mobile: data['mobile_status'] ? getChild(context) : const SizedBox(),
      tablet: data['status'] ? getChild(context) : const SizedBox(),
      desktop: data['status'] ? getChild(context) : const SizedBox(),
    );
  }

  Container getChild(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      height: 130,
      child: Center(
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: AppResponsive.isMobile(context) ? 20 : 60),
          itemCount: data['category_info'].length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 20),
          itemBuilder: (context, index) => InkWell(
            // onTap: () => navigate(context, ProductListing(catergoryId: data['category_info'][index]['category_id'].toString())),
            child: SizedBox(
              width: 80,
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.buttonColor.withOpacity(0.2),
                      // image: data['category_info'][index]['image'] != null
                      // ? DecorationImage(
                      //     image: CachedNetworkImageProvider(data['category_info'][index]['image']),
                      //     fit: BoxFit.contain,
                      //   )
                      // : null,
                    ),
                    child: data['category_info'][index]['image'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: CachedNetworkImage(imageUrl: data['category_info'][index]['image']),
                            ))
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      data['category_info'][index]['name'],
                      style: AppStyles.getRegularTextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
