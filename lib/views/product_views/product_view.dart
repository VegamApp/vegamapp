import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/product_apis.dart';
import 'package:m2/services/sliver_grid_with_fixed_height.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/error_widget.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/product_views/product_description_view.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key, this.urlKey, this.categoryId, this.categoryUid, this.viewAll = false, this.searchQuery});
  static String route = 'products';
  final String? urlKey;
  final String? searchQuery;
  final String? categoryId;
  final String? categoryUid;
  final bool viewAll;
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  late String queryString;

  final Map<String, dynamic> variables = {};
  final Map<String, dynamic> filter = {};
  final Map<String, String?> filterKeys = {'category_uid': null, 'price': null};

  int page = 1;

  @override
  void initState() {
    super.initState();
    variables.addAll({
      'pageSize': 20,
      'page': page,
    });
    getQueryString();
  }

  getQueryString() {
    filterKeys.clear();
    variables.clear();

    if (widget.viewAll == true) {
      queryString = ProductApi.viewAllProduct;
      variables.addAll({"pageSize": 20, "page": 1, "id": widget.categoryId});
      return;
    } else {
      variables.addAll({
        'filter': {},
        'pageSize': 20,
        'page': 1,
      });
      if (widget.searchQuery != null) {
        print('classicSearch');
        variables.addAll({'searchQuery': widget.searchQuery});
      } else if (widget.categoryId != null) {
        print('id');
        variables['filter'] = {
          'category_id': {'eq': widget.categoryId}
        };
      } else if (widget.urlKey != null) {
        variables['filter'] = {
          'url_key': {'eq': widget.urlKey!.split('.')[0]}
        };
      } else {
        print('uid');
        variables['filter'] = {
          'category_uid': {'eq': widget.categoryUid}
        };
      }
    }
    // variables['filter'] = filter;
    print(variables);
  }

  @override
  Widget build(BuildContext context) {
    return BuildScaffold(
      child: Query(
        options: QueryOptions(document: gql(ProductApi.products), variables: variables),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) return const BuildLoadingWidget();
          if (result.hasException) {
            return BuildErrorWidget(onRefresh: refetch, errorMsg: result.exception?.graphqlErrors[0].message);
          }
          if (result.data!['products']['items'].isEmpty) {
            return Center(child: BuildErrorWidget(onRefresh: refetch, errorMsg: "No products to show"));
          }
          if (result.data!['products']['items'].length == 1) {
            return ProductDescription(data: result.data!, refetch: refetch);
          }
          return Row(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(),
              ),
              Expanded(child: LayoutBuilder(builder: (context, constraints) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                    crossAxisCount: (constraints.maxWidth / 200).floor(),
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    height: 300.0,
                  ),
                  itemBuilder: (context, index) => Container(color: Colors.amber),
                );
              }))
            ],
          );
        },
      ),
    );
  }
}
