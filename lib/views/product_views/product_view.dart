import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/product_apis.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/models/product_model.dart' show ProductModel, Items;
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/product_views/product_description_view.dart';

class ProductView extends StatefulWidget {
  const ProductView(
      {super.key,
      this.urlKey,
      this.categoryId,
      this.categoryUid,
      this.viewAll = false,
      this.searchQuery});
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

  ProductModel productModel = ProductModel();
  List<Items> items = <Items>[];

  DraggableScrollableController dController = DraggableScrollableController();
  FetchMoreOptions? opts;
  FetchMore? fetchMore;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _filterScrollController = ScrollController();

  int page = 1;
  int totalPages = 1;
  bool isLoading = false;

  String? selectedType;

  @override
  void initState() {
    super.initState();
    variables.addAll({
      'pageSize': 20,
      'page': page,
    });
    getQueryString();
    _scrollController.addListener(() {
      print(
          'pixel ${_scrollController.position.pixels == _scrollController.position.maxScrollExtent}');
      print('page ${page <= totalPages}');
      print('isLoading $isLoading \n');
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          page <= totalPages &&
          !isLoading)) {
        //print('hi');
        page++;
        opts = FetchMoreOptions(
          document: gql(queryString),
          variables: {'page': page},
          updateQuery: (previousResultData, fetchMoreResultData) {
            //print(fetchMoreResultData);
            // this function will be called so as to combine both the original and fetchMore results
            // it allows you to combine them as you would like
            // //print(queryString);
            // //print(fetchMoreResultData);
            if (widget.viewAll != true) {
              final List<dynamic> repos = [
                ...previousResultData!['products']['items'] as List<dynamic>,
                ...fetchMoreResultData!['products']['items'] as List<dynamic>
              ];

              // to avoid a lot of work, lets just update the list of repos in returned
              // data with new data, this also ensures we have the endCursor already set
              // correctly
              fetchMoreResultData['products']['items'] = repos;
              //print(fetchMoreResultData['products']['page_info']);
            } else {
              final List<dynamic> repos = [
                ...previousResultData!['viewallProducts']['products']
                    as List<dynamic>,
                ...fetchMoreResultData!['viewallProducts']['products']
                    as List<dynamic>
              ];

              // to avoid a lot of work, lets just update the list of repos in returned
              // data with new data, this also ensures we have the endCursor already set
              // correctly
              fetchMoreResultData['viewallProducts']['products'] = repos;
            }

            return fetchMoreResultData;
          },
        );
        fetchMore!(opts!);
      }
    });
  }

  getQueryString() {
    filterKeys.clear();
    variables.clear();
    print(widget.searchQuery);
    if (widget.viewAll == true) {
      queryString = ProductApi.viewAllProduct;
      variables.addAll({"pageSize": 20, "page": 1, "id": widget.categoryId});
      return;
    } else {
      queryString = ProductApi.products;
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
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _filterScrollController.dispose();
  }

  final key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Query(
        options: QueryOptions(document: gql(queryString), variables: variables),
        builder: (result, {fetchMore, refetch}) {
          // WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => isLoading = result.isLoading));
          log('jnvueibnveir ${queryString}');
          log('jnvueibnveir ${variables}');
          if ((result.isLoading && result.data == null) || isLoading) {
            return Scaffold(
              key: key,
              appBar: BuildAppBar(
                  scaffoldKey: key,
                  height: !AppResponsive.isDesktop(context) ? 60 : 160),
              endDrawer: DrawerContainer(size: size),
              bottomNavigationBar: AppResponsive.isDesktop(context)
                  ? null
                  : const BuildBottomNavBar(currentIndex: -1),
              body: const BuildLoadingWidget(),
            );
          }
          // log(result.data.toString());
          if (result.hasException) {
            log(result.exception.toString());
            return Scaffold(
              key: key,
              appBar: BuildAppBar(
                  scaffoldKey: key,
                  height: !AppResponsive.isDesktop(context) ? 60 : 160),
              endDrawer: DrawerContainer(size: size),
              bottomNavigationBar: AppResponsive.isDesktop(context)
                  ? null
                  : const BuildBottomNavBar(currentIndex: -1),
              body: BuildErrorWidget(
                onRefresh: refetch,
                errorMsg: result.exception!.graphqlErrors.isEmpty
                    ? "Server error"
                    : result.exception?.graphqlErrors[0].message,
              ),
            );
          }
          if ((widget.viewAll != true &&
                  result.data!['products']['items'].isEmpty) ||
              (widget.viewAll == true &&
                  result.data!['viewallProducts']['products'].isEmpty)) {
            log('bfudrbgr ${result.data!['products']['items']}');
            return Scaffold(
                key: key,
                appBar: BuildAppBar(
                    scaffoldKey: key,
                    height: !AppResponsive.isDesktop(context) ? 60 : 160),
                endDrawer: DrawerContainer(size: size),
                bottomNavigationBar: AppResponsive.isDesktop(context)
                    ? null
                    : const BuildBottomNavBar(currentIndex: -1),
                body: Center(
                    child: BuildErrorWidget(
                        onRefresh: refetch, errorMsg: "No products to show")));
          }

          // log(jsonEncode(result.data));
          if (((widget.viewAll != true &&
                  result.data!['products']['items'].length == 1) ||
              (widget.viewAll == true &&
                  result.data!['viewallProducts']['products'].length == 1))) {
            return Scaffold(
                key: key,
                appBar: BuildAppBar(
                    scaffoldKey: key,
                    height: !AppResponsive.isDesktop(context) ? 60 : 160),
                endDrawer: DrawerContainer(size: size),
                bottomNavigationBar: AppResponsive.isDesktop(context)
                    ? null
                    : const BuildBottomNavBar(currentIndex: -1),
                body: ProductDescription(data: result.data!, refetch: refetch));
          }
          widget.viewAll != true
              ? productModel = ProductModel.fromJson(result.data!['products'])
              : items =
                  (result.data!['viewallProducts']['products'] as List<dynamic>)
                      .map((item) => Items.fromJson(item))
                      .toList();
          // log(jsonEncode(result.data));
          // print(productModel.pageInfo!.toJson());
          // page = productModel.pageInfo!.currentPage!;
          // totalPages = productModel.pageInfo!.totalPages!;
          if (widget.viewAll != true) {
            final Map pageInfo = result.data!['products']['page_info'];
            page = pageInfo['current_page'];
            totalPages = pageInfo['total_pages'];
          } else {
            totalPages =
                (result.data!['viewallProducts']['total_count'] / 20).ceil();
          }
          print('totalPages $totalPages');
          print('page $page');

          // if (result.isConcrete) {
          //   isLoading = false;
          // }

          this.fetchMore = fetchMore;

          return WillPopScope(
            onWillPop: () async {
              // //print(dController.size);
              if (widget.viewAll != true && dController.size > 0.075) {
                dController.animateTo(0.075,
                    curve: Curves.decelerate,
                    duration: const Duration(milliseconds: 200));
                return false;
              }
              return true;
            },
            child: Scaffold(
              key: key,
              appBar: BuildAppBar(
                  scaffoldKey: key,
                  height: !AppResponsive.isDesktop(context) ? 60 : 160),
              endDrawer: DrawerContainer(size: size),
              bottomNavigationBar: AppResponsive.isDesktop(context)
                  ? null
                  : const BuildBottomNavBar(currentIndex: -1),
              floatingActionButton: AppResponsive.isDesktop(context)
                  ? null
                  : dController.isAttached && dController.pixels == 0
                      ? FloatingActionButton.extended(
                          onPressed: () async {
                            await dController.animateTo(1,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn);
                            setState(() {});
                          },
                          backgroundColor: AppColors.primaryColor,
                          isExtended: true,
                          label: Text('Filters',
                              style: AppStyles.getMediumTextStyle(
                                  fontSize: 14,
                                  color: AppColors.scaffoldColor)),
                        )
                      : FloatingActionButton(
                          onPressed: () async {
                            await dController.animateTo(0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn);
                            setState(() {});
                          },
                          backgroundColor: AppColors.primaryColor,
                          isExtended: true,
                          child: Icon(Icons.close,
                              color: AppColors.scaffoldColor, size: 20),
                        ),
              body: Row(
                children: [
                  if (AppResponsive.isDesktop(context))
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: getFilter(size, result, refetch),
                      ),
                    ),
                  const VerticalDivider(),
                  Expanded(
                    flex: 8,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            ListView(
                              padding: const EdgeInsets.all(20.0),
                              controller: _scrollController,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                widget.searchQuery != null
                                    ? Text(
                                        'Search result for "${widget.searchQuery}"',
                                        style: AppStyles.getMediumTextStyle(
                                            fontSize: 16,
                                            color: AppColors.fadedText))
                                    : MiniAppBar(
                                        navigationChild: widget.viewAll
                                            ? result.data!['viewallProducts']
                                                ['products'][0]['categories']
                                            : result.data!['products']['items']
                                                [0]['categories'],
                                        screenWidth: constraints.maxWidth),
                                const SizedBox(height: 10),
                                GridView.builder(
                                  // padding: const EdgeInsets.all(20),
                                  itemCount: productModel.items?.length ??
                                      items.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 400,
                                          // crossAxisCount: constraints.maxWidth < 600 ? 2 : (constraints.maxWidth / 280).floor(),
                                          crossAxisSpacing:
                                              constraints.maxWidth < 800
                                                  ? 10
                                                  : 40,
                                          mainAxisSpacing:
                                              constraints.maxWidth < 800
                                                  ? 10
                                                  : 40,
                                          mainAxisExtent: 400
                                          // height: getGridViewHeight(constraints.maxWidth),
                                          ),
                                  itemBuilder: (context, index) {
                                    var price = productModel.items != null
                                        ? productModel.items![index].priceRange!
                                            .minimumPrice!.regularPrice!.value
                                            .toString()
                                        : items[index]
                                            .priceRange!
                                            .minimumPrice!
                                            .regularPrice!
                                            .value
                                            .toString();
                                    var originalPrice =
                                        productModel.items == null
                                            ? items[index]
                                                .priceRange!
                                                .maximumPrice!
                                                .regularPrice!
                                                .value
                                                .toString()
                                            : productModel
                                                .items![index]
                                                .priceRange!
                                                .maximumPrice!
                                                .regularPrice!
                                                .value
                                                .toString();
                                    var offer = productModel.items == null
                                        ? items[index]
                                            .priceRange!
                                            .maximumPrice!
                                            .discount!
                                            .percentOff
                                            .toString()
                                        : productModel.items![index].priceRange!
                                            .maximumPrice!.discount!.percentOff
                                            .toString();
                                    return ProductItem(
                                      productModel:
                                          productModel.items?[index] ??
                                              items[index],
                                      price: price,
                                      originalPrice: originalPrice,
                                      offer: offer,
                                      sku: productModel.items?[index].sku ??
                                          items[index].sku!,
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                if (result.isLoading || totalPages >= page)
                                  Center(
                                      child: BuildLoadingWidget(
                                          color: AppColors.primaryColor)),
                                const SizedBox(height: 20),
                              ],
                            ),
                            if (productModel.aggregations != null &&
                                productModel.aggregations!.isNotEmpty)
                              DraggableScrollableActuator(
                                child: DraggableScrollableSheet(
                                  controller: dController,
                                  initialChildSize: 0,
                                  minChildSize: 0,
                                  maxChildSize: 1,
                                  snap: true,
                                  builder: (context, scrollController) {
                                    return getFilter(size, result, refetch,
                                        scrollController: scrollController);
                                  },
                                ),
                              )
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  getGridViewHeight(double width) {
    print(width);
    // if (width > 500) return 400.0;
    // if (width > 450) return width * 0.9;
    // if (width > 400) return width;
    // if (width > 350) return width * 1.05;
    // if (width > 300) return width * 1.1;
    // if (width > 250) return width * 1.2;
    // return width * 1.3;
    return 400.0;
  }

  getFilter(Size size, QueryResult result, VoidCallback? refetch,
      {ScrollController? scrollController}) {
    // //print(jsonEncode(result.data));
    if (result.data!['products']['aggregations'] == null ||
        result.data!['products']['aggregations'].isEmpty) {
      return Center(
        child: Text('No filters available',
            style: AppStyles.getRegularTextStyle(fontSize: 13)),
      );
    }
    return StatefulBuilder(builder: (context, setState) {
      // //print(dController.pixels);
      return Container(
        decoration: BoxDecoration(
          color: AppColors.scaffoldColor,
          // gradient: LinearGradient(
          // colors: const [Colors.transparent, Colors.white],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   stops: dController.isAttached ? [dController.pixels > 100 ? 0.3 : 0.7, dController.pixels > 100 ? 0.3 : 0.7] : [0.3, 0.7],
          // ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          controller: scrollController ?? _filterScrollController,
          children: [
            // if (!AppResponsive.isDesktop(context))
            //   InkWell(
            //     onTap: () {
            //       if (dController.pixels > 100) {
            //         dController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
            //       } else {
            //         dController.animateTo(1, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
            //       }
            //     },
            //     child: SizedBox(
            //       height: size.height * 0.06,
            //       child: Stack(
            //         children: [
            //           Align(
            //             alignment: Alignment.bottomCenter,
            //             child: Container(
            //               height: size.height * 0.03,
            //               decoration: BoxDecoration(
            //                 color: AppColors.primaryColor,
            //                 borderRadius: const BorderRadius.vertical(top: Radius.circular(100)),
            //               ),
            //             ),
            //           ),
            //           Align(
            //             alignment: Alignment.bottomCenter,
            //             child: SizedBox(
            //               // color: Colors.amber,
            //               width: size.height * 0.09,
            //               height: size.height * 0.06,
            //               child: Stack(
            //                 children: [
            //                   Align(
            //                     alignment: Alignment.topCenter,
            //                     child: Transform.translate(offset: Offset(0, size.height * 0.005), child: SvgPicture.asset('assets/svg/filter.svg')),
            //                   ),
            //                   const Center(child: Icon(Icons.tune, color: Colors.white)),
            //                 ],
            //               ),
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   )
            // else
            const SizedBox(height: 20),

            Text('Filters',
                style: AppStyles.getRegularTextStyle(
                    fontSize: 18, color: AppColors.fontColor)),
            const SizedBox(height: 20),
            Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: result.data!['products']['aggregations'].length,
                // separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) => getFilterWiget(
                    result.data!['products']['aggregations'][index], size),
              ),
            ),
            Container(color: Colors.white, height: 20),
            Container(
              color: Colors.white,
              height: 50,
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          backgroundColor: Colors.white,
                          shape: StadiumBorder(
                              side: BorderSide(color: AppColors.fadedText)),
                        ),
                        onPressed: () {
                          getQueryString();
                          isLoading = true;
                          //print(variables);
                          refetch!();
                          try {
                            dController.reset();
                          } catch (e) {}

                          // Navigator.pop(context);
                          // clearFilter(result);
                        },
                        child: Text(
                          'Clear',
                          style: AppStyles.getSemiBoldTextStyle(
                              fontSize: 12, color: AppColors.fadedText),
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          backgroundColor: AppColors.primaryColor,
                          shape: const StadiumBorder(),
                          // fixedSize: Size(size.width * 0.4, 50),
                          // maximumSize: const Size(150, 50),
                        ),
                        onPressed: () {
                          //print(variables);

                          // queryString = ProductQueries.filterProduct(filterAttribute: filteringAttributes.toString());
                          // Navigator.pop(context);
                          isLoading = true;
                          refetch!();
                          try {
                            dController.reset();
                          } catch (e) {}

                          setState(() {});
                        },
                        child: Text(
                          'Apply Filter',
                          style: AppStyles.getSemiBoldTextStyle(
                              fontSize: 12, color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
            Container(color: Colors.white, height: 20),
          ],
        ),
      );
    });
  }

  getFilterWiget(var data, Size size) {
    return StatefulBuilder(builder: (context, setState) {
      if (data['attribute_code'] == 'price' && data['options'].length > 1) {
        return getPriceSlider(data);
      }
      //print(filter);
      return ExpansionTile(
          initiallyExpanded: false,
          // tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          controlAffinity: ListTileControlAffinity.leading,
          leading: const SizedBox(),
          tilePadding: EdgeInsets.zero,
          onExpansionChanged: (value) => setState(() {
                selectedType = data['attribute_code'];
              }),
          title: Transform.translate(
            offset: const Offset(-50, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppColors.primaryColor, width: 2.0))),
                  child: Text(
                    data['label'],
                    style: data['attribute_code'] == selectedType
                        ? AppStyles.getMediumTextStyle(
                            fontSize: 14, color: AppColors.fadedText)
                        : AppStyles.getRegularTextStyle(
                            fontSize: 14, color: AppColors.fadedText),
                  ),
                ),
              ],
            ),
          ),
          children: List.generate(
            data['options'].length,
            (index) => data['attribute_code'] != 'category_uid' &&
                    data['attribute_code'] != 'category_id'
                ? RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    value: data['options'][index]['value'].toString(),
                    groupValue: filterKeys[data['attribute_code']],
                    onChanged: (value) {
                      // log(jsonEncode(data));

                      //print(data['attribute_code']);
                      //print(filter);
                      // filter.clear();
                      filter[data['attribute_code']] = {
                        'eq': data['options'][index]['value']
                      };
                      variables['filter'] = filter;
                      filterKeys[data['attribute_code']] =
                          data['options'][index]['value'];
                      //print('variables $variables');

                      //print(variables);
                      setState(() {});
                    },
                    title: Text(data['options'][index]['label'],
                        style: AppStyles.getRegularTextStyle(fontSize: 12)),
                  )
                : ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/images/categoryicon.png')),
                    trailing: data['options'][index]['value'].toString() ==
                            filterKeys[data['attribute_code']]
                        ? Icon(Icons.check, color: AppColors.primaryColor)
                        : null,
                    // value: data['options'][index]['value'].toString(),
                    // groupValue: filterKeys[data['attribute_code']],
                    onTap: () {
                      //print(data);
                      if (data['attribute_code'] == 'category_uid') {
                        if (variables['filter']['category_uid'] != null) {
                          variables['filter'].remove('category_uid');
                        }
                        filter.addAll({
                          'category_uid': {
                            'eq': data['options'][index]['value']
                          }
                        });
                        variables['filter'] = filter;
                        try {
                          variables['filter'].remove("category_id");
                        } catch (e) {
                          //print(e);
                        }
                        filterKeys[data['attribute_code']] =
                            data['options'][index]['value'];
                        //print(variables);
                        queryString = ProductApi.products;
                      } else {
                        if (variables['filter']['category_id'] != null) {
                          variables['filter'].remove('category_id');
                        }
                        filter.addAll({
                          'category_id': {'eq': data['options'][index]['value']}
                        });
                        try {
                          variables['filter'].remove("category_uid");
                        } catch (e) {
                          //print(e);
                        }
                        variables['filter'] = filter;
                        filterKeys[data['attribute_code']] =
                            data['options'][index]['value'];
                        //print(variables);
                        queryString = ProductApi.products;
                      }

                      //print(variables);
                      setState(() {});
                    },
                    title: Text(data['options'][index]['label'],
                        style: AppStyles.getRegularTextStyle(fontSize: 12)),
                  ),
          ));
    });
    // } catch (e) {
    //   //print(e);
    //   return const SizedBox();
    // }
    // }
  }

  RangeValues? rangeValues;
  getPriceSlider(var data) {
    // //print(jsonEncode(data));
    if (rangeValues == null ||
        rangeValues !=
            RangeValues(
                double.parse(data['options'][0]['value'].split('_')[0]),
                double.parse(data['options'][data['options'].length - 1]
                        ['value']
                    .split('_')[1]))) {
      rangeValues = RangeValues(
          double.parse(data['options'][0]['value'].split('_')[0]),
          double.parse(data['options'][data['options'].length - 1]['value']
              .split('_')[1]));
    }
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: AppColors.primaryColor, width: 2.0))),
            child: Text(
              data['label'],
              style: data['attribute_code'] == selectedType
                  ? AppStyles.getMediumTextStyle(
                      fontSize: 14, color: AppColors.fadedText)
                  : AppStyles.getRegularTextStyle(
                      fontSize: 14, color: AppColors.fadedText),
            ),
          ),
          RangeSlider(
            labels: RangeLabels(rangeValues!.start.round().toString(),
                rangeValues!.end.round().toString()),
            min: double.parse(data['options'][0]['value'].split('_')[0]),
            max: double.parse(data['options'][data['options'].length - 1]
                    ['value']
                .split('_')[1]),
            values: rangeValues!,
            onChanged: (values) {
              rangeValues = values;
              setState(() {});
              filterKeys[data['attribute_code']] = data['attribute_code'];
              filter.addAll({
                'price': {
                  'from': values.start.round(),
                  'to': values.end.round()
                }
              });
              filter.addAll(Map<String, dynamic>.from(variables['filter']));

              variables['filter'] = filter;
              // //print(variables);
            },
          ),
          const SizedBox(height: 10),
          Text(
            'Price: $currency${rangeValues!.start.round()} - $currency${rangeValues!.end.round()}',
            style:
                AppStyles.getRegularTextStyle(fontSize: 14, isCurrency: true),
          ),
          const SizedBox(height: 10),
        ],
      );
    });
  }
}
