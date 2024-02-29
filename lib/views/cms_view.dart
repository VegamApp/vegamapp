import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:m2/services/api_services/api_services.dart';

import '../services/app_responsive.dart';
import '../utilities/utilities.dart';
import '../utilities/widgets/widgets.dart';

class CmsView extends StatefulWidget {
  const CmsView({super.key, this.id});
  static String route = 'cms';
  final String? id;
  @override
  State<CmsView> createState() => _CmsViewState();
}

// CMS pages with the passed id from line no: 14
class _CmsViewState extends State<CmsView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BuildScaffold(
        child: Query(
            options: QueryOptions(document: gql(ApiServices.getCmsInfo), variables: {'id': widget.id}),
            builder: (QueryResult result, {FetchMore? fetchMore, VoidCallback? refetch}) {
              if (result.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.buttonColor,
                  ),
                );
              }
              if (result.data == null || result.hasException) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    // alignment: Alignment.center,
                    // height: 200,
                    child: Text(
                      result.exception?.graphqlErrors[0].message ?? 'An error occured, Please try again',
                      style: AppStyles.getRegularTextStyle(
                        fontSize: 14,
                        color: AppColors.fadedText,
                      ),
                    ),
                  ),
                );
              }

              return AppResponsive(
                  mobile: _getMobileView(size, result),
                  desktop: Center(
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 100),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 3, child: _getHeading(result.data!['cmsPage']['title'])),
                                  Expanded(flex: 7, child: _getBody(result.data!['cmsPage']['content'])),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
            }));
  }

  Widget _getMobileView(Size size, QueryResult result) {
    return Padding(
      padding: const EdgeInsets.all(20).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getHeading(result.data!['cmsPage']['title']),
          const SizedBox(height: 15),
          Flexible(
            child: _getBody(result.data!['cmsPage']['content']),
          ),
          // const SizedBox(height: 30),
        ],
      ),
    );
  }

  _getBody(String details) {
    // Initialize web view controller with the content
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(0, 255, 255, 255))
      ..loadHtmlString('<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width, initial-scale=0.8"></head>$details');

    return WebViewWidget(
      controller: controller,
    );
  }

  Text _getHeading(String title) => Text(title, style: AppStyles.getLightTextStyle(fontSize: 25, color: AppColors.fadedText));
}
