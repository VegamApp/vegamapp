import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/api_services/api_services.dart';
import 'package:m2/services/search_services.dart';
import 'package:m2/utilities/app_colors.dart';
import 'package:m2/utilities/app_style.dart';
import 'package:m2/views/product_views/product_view.dart';

class AppbarSearchService extends StatefulWidget {
  const AppbarSearchService({super.key});

  @override
  State<AppbarSearchService> createState() => _AppbarSearchServiceState();
}

class _AppbarSearchServiceState extends State<AppbarSearchService> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFieldSearch(
      label: 'Search',
      controller: _controller,
      future: () => ApiServices().searchSuggessionApi(searchQuery: _controller.text, context: context),
      itemsInView: 5,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(300),
          borderSide: BorderSide(color: AppColors.evenFadedText),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(300),
          borderSide: BorderSide(color: AppColors.evenFadedText),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: "Search",
        hintStyle: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.primaryColor),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            splashRadius: 25,
            onPressed: () {
              context.push(Uri(path: '/${ProductView.route}', queryParameters: {"search": _controller.text}).toString());
            },
            icon: Icon(Icons.search, color: AppColors.fadedText),
          ),
        ),
      ),
      onSubmitted: (value) => context.push(Uri(path: '/${ProductView.route}', queryParameters: {"search": _controller.text}).toString()),
    );
    //          TextField(
    //   controller: _controller,
    //   decoration: InputDecoration(
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(300),
    //       borderSide: BorderSide(color: AppColors.evenFadedText),
    //     ),
    //     enabledBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(300),
    //       borderSide: BorderSide(color: AppColors.evenFadedText),
    //     ),

    //     hintText: "Search",
    //     hintStyle: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.primaryColor),
    //   ),
    //   style: AppStyles.getRegularTextStyle(fontSize: 14),
    // );
  }
}
