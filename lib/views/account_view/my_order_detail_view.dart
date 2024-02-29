
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/account_sidebar.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/account_view/orders_view.dart';
import 'package:m2/views/product_views/product_view.dart';

class MyOrderDetailView extends StatefulWidget {
  const MyOrderDetailView({super.key, required this.orderId});
  final String orderId;
  @override
  State<MyOrderDetailView> createState() => _MyOrderDetailViewState();
}

class _MyOrderDetailViewState extends State<MyOrderDetailView> {
  @override
  void initState() {
    super.initState();
    print(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BuildScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
        return Query(
            options: QueryOptions(document: gql(orderDetails), fetchPolicy: FetchPolicy.noCache, variables: {
              'filter': {
                "number": {"eq": widget.orderId}
              }
            }),
            builder: (result, {fetchMore, refetch}) {
              if (result.isLoading) {
                return BuildLoadingWidget(color: AppColors.primaryColor);
              }
              if (result.hasException) {
                return Center(
                  child: BuildErrorWidget(
                    errorMsg: result.exception?.graphqlErrors[0].message,
                    onRefresh: refetch,
                  ),
                );
              }
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 1400 ? (constraints.maxWidth - 1400) / 2 : 20, vertical: 20),
                child: AppResponsive(
                  mobile: _getMobileView(size, result.data!),
                  desktop: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.2,
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: AccountSideBar(currentPage: OrdersView.route),
                      ),
                      Expanded(child: _getMobileView(size, result.data!))
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }

  Padding _getMobileView(Size size, Map data) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My orders', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.primaryColor)),
          const SizedBox(height: 10),
          Text('Order No: ${widget.orderId}', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.evenFadedText)),
          const SizedBox(height: 20),
          ListView.separated(
            itemCount: data['customer']['orders']['items'][0]['items'].length,
            shrinkWrap: true,
            separatorBuilder: (ctx, index) => !AppResponsive.isDesktop(context)
                ? const SizedBox(height: 40)
                : Column(
                    children: [
                      const SizedBox(height: 40),
                      Divider(height: 1, color: AppColors.evenFadedText),
                      const SizedBox(height: 40),
                    ],
                  ),
            itemBuilder: (context, index) => BuildOrderDetailContainer(
              data: data['customer']['orders']['items'][0]['items'][index],
              size: size,
              orderId: widget.orderId,
            ),
          ),
        ],
      ),
    );
  }

  String orderDetails = r'''
  query Orders($filter:CustomerOrdersFilterInput!){
    customer {
      orders(filter:$filter,currentPage: 1, pageSize:10){
        items {
          number
          id
          order_date
          status
          total{
            grand_total{
              value
            }
          }
          items{
            product_name
            status
            product_sku
            product_url_key
            quantity_ordered
            product_sale_price{
                value
            }
          }
          status
        }
        page_info {
          current_page
          page_size
          total_pages
        }
      }
    }
  }
  ''';
}

class BuildOrderDetailContainer extends StatefulWidget {
  const BuildOrderDetailContainer({super.key, required this.size, required this.orderId, this.isReturn = false, required this.data});
  final Size size;
  final String orderId;
  final bool isReturn;
  final Map data;
  @override
  State<BuildOrderDetailContainer> createState() => _BuildOrderDetailContainerState();
}

class _BuildOrderDetailContainerState extends State<BuildOrderDetailContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.data);
        context.push('/${ProductView.route}/${widget.data['product_url_key']}');
      },
      child: SizedBox(
        width: widget.size.width,
        child: AppResponsive(
          mobile: _getMobileView(),
          desktop: Row(
            children: [
              Flexible(flex: 5, child: _getOrderDetails()),
              const Spacer(),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _getOrderPrice(),
                    // _getOrderDelivery(),
                    _orderCancelButton(),
                    _trackOrderButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _getMobileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getOrderDetails(),
        const SizedBox(height: 20),
        _getOrderPrice(),
        const SizedBox(height: 10),
        // _getOrderDelivery(),
        // const SizedBox(height: 10),
        if (!widget.isReturn)
          SizedBox(
            width: widget.size.width,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                _trackOrderButton(),
                _orderCancelButton(),
              ],
            ),
          ),
        if (widget.isReturn) _returnButton()
      ],
    );
  }

  Row _getOrderDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // _getProductContainer(),
        // const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data['product_name'],
                style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.fontColor),
              ),
              const SizedBox(height: 5),
              Text(
                'Order details',
                style: AppStyles.getMediumTextStyle(fontSize: 12, color: AppColors.primaryColor),
              ),
              const SizedBox(height: 5),
              Container(height: 1, color: AppColors.buttonColor),
              const SizedBox(height: 5),
              Text(
                'Order status : ${widget.data['status']}',
                style: AppStyles.getRegularTextStyle(fontSize: 12, color: AppColors.fadedText),
              ),
              const SizedBox(height: 5),
              // Text(
              //   'Payement Methods : Cash On Delivery',
              //   style: AppStyles.getRegularTextStyle(fontSize: 12, color: AppColors.fadedText),
              // ),
            ],
          ),
        )
      ],
    );
  }

  TextButton _returnButton() {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: () {},
      child: Text('Returns', style: AppStyles.getMediumTextStyle(fontSize: 17, color: Colors.red)),
    );
  }

  TextButton _orderCancelButton() {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: () {},
      child: Text('Cancel Order', style: AppStyles.getMediumTextStyle(fontSize: 17, color: AppColors.fadedText)),
    );
  }

  TextButton _trackOrderButton() {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: () {},
      child: Text('Track Order', style: AppStyles.getMediumTextStyle(fontSize: 17, color: AppColors.buttonColor)),
    );
  }

  // Text _getOrderDelivery() {
  //   return const Text(
  //     'Delivery Expected Thu May 13 2021',
  //     style: TextStyle(
  //       fontFamily: 'Poppins',
  //       fontSize: 13,
  //       color: Color(0xff707070),
  //     ),
  //   );
  // }

  Text _getOrderPrice() {
    return Text.rich(
      TextSpan(
        text: "Total Price: ",
        style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.fontColor),
        children: [
          TextSpan(
            text: currency,
            style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.fontColor),
          ),
          TextSpan(text: widget.data['product_sale_price']['value'].toStringAsFixed(2), style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.fontColor)),
        ],
      ),
    );
  }

  // Container _getProductContainer() {
  //   return Container(
  //     constraints: const BoxConstraints(maxHeight: 100, maxWidth: 100),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: const Color(0xffffffff),
  //       borderRadius: BorderRadius.circular(7.0),
  //       border: Border.all(width: 1.0, color: AppColors.evenFadedText),
  //     ),
  //     child: Text(
  //         // images[0],
  //         widget.data.toString()),
  //   );
  // }
}
