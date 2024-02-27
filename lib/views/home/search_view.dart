import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2/services/api_services/api_services.dart';
import 'package:m2/services/search_services.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/scaffold_body.dart';
import 'package:m2/views/product_views/product_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});
  static String route = 'search';
  @override
  State<SearchView> createState() => _SearchViewState();
}

// Only on mobile. Seperate page for search

class _SearchViewState extends State<SearchView> {
  List<String> dropDownItem = ['All', 'Mobile', 'Accessories'];
  String dropDownValue = 'All';
  TextEditingController searchQuery = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BuildScaffold(
      currentIndex: 1,
      child: Column(
        children: [
          Container(
            width: size.width,
            height: 50,
            margin: EdgeInsets.all(size.width * 0.05),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 1, color: AppColors.fadedText),
            ),
            child: TextFieldSearch(
              label: 'Search',
              controller: searchQuery,
              future: () => ApiServices().searchSuggessionApi(searchQuery: searchQuery.text, context: context),
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
                      context.push(Uri(path: '/${ProductView.route}', queryParameters: {"search": searchQuery.text}).toString());
                    },
                    icon: Icon(Icons.search, color: AppColors.fadedText),
                  ),
                ),
              ),
              onSubmitted: (value) => context.push(Uri(path: '/${ProductView.route}', queryParameters: {"search": searchQuery.text}).toString()),
            ),
          ),
        ],
      ),
    );
  }
}
