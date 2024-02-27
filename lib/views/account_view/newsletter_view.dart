import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/services/state_management/user/user_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/account_sidebar.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NewsletterView extends StatefulWidget {
  const NewsletterView({super.key});
  static String route = 'newsletters';
  @override
  State<NewsletterView> createState() => _NewsletterViewState();
}

class _NewsletterViewState extends State<NewsletterView> {
  TextEditingController email = TextEditingController();

  late UserData userData;
  late AuthToken authToken;
  bool newsletter = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userData = Provider.of<UserData>(context);
    authToken = Provider.of<AuthToken>(context);
    newsletter = userData.data.isSubscribed == true;
  }

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
                    child: AccountSideBar(currentPage: NewsletterView.route),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    constraints: const BoxConstraints(minHeight: 400),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldColor,
                      boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 50, offset: const Offset(0, 10))],
                    ),
                    child: getBody(context, size),
                  ),
                ),
              ],
            ),
            mobile: getBody(context, size),
          ),
        );
      }),
    );
  }

  getBody(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Newsletter subscription',
            style: AppStyles.getBoldTextStyle(fontSize: 20, color: AppColors.primaryColor),
            softWrap: false,
          ),
          const SizedBox(height: 20),
          // Container(
          //   // width: widget.width,
          //   height: 50,
          //   // padding: EdgeInsets.only(left: widget.width * 0.05),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(41.0),
          //     border: Border.all(width: 1.0, color: AppColors.evenFadedText),
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         flex: 70,
          //         // color: Colors.green,
          //         // height: 50,
          //         // width: widget.width * 0.75,
          //         child: TextFormField(
          //           controller: email,
          //           decoration: InputDecoration(
          //             border: InputBorder.none,
          //             contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          //             hintText: 'Email',
          //             hintStyle: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.evenFadedText),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         flex: 30,
          //         child: TextButton(
          //           onPressed: () {},
          //           //  sendEmail,
          //           style: TextButton.styleFrom(
          //             minimumSize: Size.infinite,
          //             backgroundColor: AppColors.buttonColor,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(41),
          //             ),
          //           ),
          //           child: Text('Send', style: AppStyles.getRegularTextStyle(fontSize: 15, color: Colors.white)),
          //         ),
          //       )
          //     ],
          //   ),
          // )

          Mutation(
              options: MutationOptions(
                document: gql(mutationStirng),
                onCompleted: (data) {
                  log(data.toString());
                  userData.getUserData(context);
                },
                onError: (error) {
                  log(error.toString());
                },
              ),
              builder: (runMutation, result) {
                return ListTile(
                  onTap: () {
                    newsletter = !newsletter;
                    runMutation({'email': userData.data.email});
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: result!.isLoading
                      ? BuildLoadingWidget(color: AppColors.buttonColor)
                      : IgnorePointer(
                          child: Checkbox(
                            value: newsletter,
                            onChanged: (value) => setState(() => newsletter = value!),
                          ),
                        ),
                  title: Text("Subscribe to Newsletter", style: AppStyles.getMediumTextStyle(fontSize: 16)),
                );
              })
        ],
      ),
    );
  }

  String mutationStirng = r"""mutation subscribeEmailToNewsletter($email: String!){
            subscribeEmailToNewsletter(
              email:$email
            ) {
              status
            }
          }""";
}
