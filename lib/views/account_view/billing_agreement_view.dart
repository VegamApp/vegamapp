import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:m2/services/api_services/customer_apis.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/account_sidebar.dart';
import 'package:m2/utilities/widgets/widgets.dart';

class BillingAgreementsView extends StatefulWidget {
  const BillingAgreementsView({super.key});
  static String route = 'billing';
  @override
  State<BillingAgreementsView> createState() => _BillingAgreementsViewState();
}

class _BillingAgreementsViewState extends State<BillingAgreementsView> {
  List<String> headers = ['Order', 'Date', 'Ship To', 'Order Total', 'Action'];
  DateFormat dateFormat = DateFormat('MM/dd/yyyy');
  int page = 1;
  int totalPage = 1;

  FetchMoreOptions? opts;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BuildScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.isMobile(context)
                  ? 20
                  : constraints.maxWidth > 1400
                      ? (constraints.maxWidth - 1400) / 2
                      : 60,
              vertical: 20),
          child: AppResponsive(
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: AccountSideBar(currentPage: BillingAgreementsView.route),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldColor,
                        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 50, offset: const Offset(0, 10))],
                      ),
                      child: getBody(context, size)),
                ),
              ],
            ),
            mobile: getBody(context, size),
          ),
        );
      }),
    );
  }

  Padding getBody(BuildContext context, Size size) {
    return Padding(
      padding: AppResponsive.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: 60, vertical: 50) : EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text('Billing Agreements', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.primaryColor)),
          ),
          const SizedBox(height: 30),
          getTableQuery(size),
        ],
      ),
    );
  }

  getTableQuery(Size size) {
    // generate table
    return Query(
        options: QueryOptions(document: gql(CustomerApis.orderDetails), variables: {'page': page}, fetchPolicy: FetchPolicy.noCache),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading && result.data == null) {
            return Center(child: BuildLoadingWidget(color: AppColors.primaryColor));
          }
          if (result.data == null) {
            return BuildErrorWidget(onRefresh: refetch);
          }
          log(jsonEncode(result.data!));
          try {
            var pageInfo = result.data!['customer']['orders']['page_info'];

            page = pageInfo['current_page'];
            totalPage = pageInfo['total_pages'];
          } catch (e) {}

          if (result.data!['customer']['orders']['items'].isEmpty) {
            return SizedBox(
              height: 200,
              child: Center(child: Text("No orders yet", style: AppStyles.getMediumTextStyle(fontSize: 15, color: AppColors.primaryColor))),
            );
          }
          // if (opts == null)
          opts = FetchMoreOptions(
            document: gql(CustomerApis.orderDetails),
            variables: {'page': ++page},
            updateQuery: (previousResultData, fetchMoreResultData) {
              //print('currentReviewPage $page');
              // //print('fetchMoreResultData $fetchMoreResultData');

              final List<dynamic> repos = [
                ...previousResultData!['customer']['orders']['items'] as List<dynamic>,
                ...fetchMoreResultData!['customer']['orders']['items'] as List<dynamic>
              ];

              // to avoid a lot of work, lets just update the list of repos in returned
              // data with new data, this also ensures we have the endCursor already set
              // correctly
              fetchMoreResultData['customer']['orders']['items'] = repos;

              return fetchMoreResultData;
            },
          ); // List<Orders> products = List.generate(
          //     result.data!['customerOrders']['items']!.length, (index) => Orders.fromJson(result.data!['customerOrders']['items'][index]));
          // List<Orders> products = List.generate(data.length, (index) => Orders.fromJson(data[index]));
          return Column(
            children: [
              BuildTableWidget(
                size: size,
                headers: headers,
                id: List.generate(result.data!['customer']['orders']['items'].length, (index) => result.data!['customer']['orders']['items'][index]['number'].toString()),
                cells: List<Map<String, dynamic>>.generate(
                    result.data!['customer']['orders']['items'].length,
                    (index) => {
                          'data': result.data!['customer']['orders']['items'][index],
                          'list': [
                            result.data!['customer']['orders']['items'][index]['number'],
                            dateFormat.format(DateTime.parse(result.data!['customer']['orders']['items'][index]['order_date'])),
                            double.parse(result.data!['customer']['orders']['items'][index]['total']['grand_total']['value'].toString()).toStringAsFixed(2),
                            result.data!['customer']['orders']['items'][index]['status'],
                            'View Order'
                          ],
                        }),
                onTap: 'MyOrderDetailView',
              ),
              const SizedBox(height: 10),
              if (totalPage >= page)
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      shape: const StadiumBorder(),
                      backgroundColor: AppColors.primaryColor,
                      shadowColor: AppColors.shadowColor,
                    ),
                    onPressed: () {
                      // //print(opts);
                      ++page;
                      fetchMore!(opts!);
                    },
                    child: result.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                        : Text(
                            'Load More',
                            style: AppStyles.getMediumTextStyle(fontSize: 14, color: Colors.white),
                          ),
                  ),
                ),
            ],
          );
        });
  }
}
