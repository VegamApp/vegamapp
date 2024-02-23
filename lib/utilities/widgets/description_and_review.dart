import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/product_apis.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:m2/views/auth/sign_in.dart';

class BuildDescriptionReview extends StatefulWidget {
  const BuildDescriptionReview({super.key, required this.width, required this.description, this.highlight, required this.sku});
  final double width;
  final String description;
  final String? highlight;
  final String sku;
  @override
  State<BuildDescriptionReview> createState() => BuildDescriptionReviewState();
}

class BuildDescriptionReviewState extends State<BuildDescriptionReview> {
  int currentIndex = 0;
  List<Widget>? child;
  late String getReviews;
  @override
  void initState() {
    super.initState();
    getReviews = '''
      {
        products(
          filter: {
            sku: {
              eq: "${widget.sku}"
            }
          } 
        ) {
        
          
          items{
            name
            rating_summary
            review_count
            reviews{
              items {
                average_rating
                created_at
                nickname
                ratings_breakdown {
                  name
                  value
                }
                summary
                text
              } 
              page_info {
                current_page
                page_size
                total_pages
              }
            }
          
          }
          
        }
      }''';
    child = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildTitleDetail(title: '', detail: widget.description),
        ],
      ),
      Query(
        options: QueryOptions(document: gql(getReviews)),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return SizedBox(
              height: 100,
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: AppColors.buttonColor),
                ),
              ),
            );
          }
          print('rgetr ${result.data!['products']['items'][0]['reviews']['items'][0]['nickname']}');

          // //print(jsonEncode(result.data));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (result.data!['products']['items'][0]['reviews']['items'].isEmpty)
                  ? SizedBox(height: 100, child: Center(child: Text('No reviews yet.', style: AppStyles.getRegularTextStyle(fontSize: 14))))
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemCount: result.data!['products']['items'][0]['reviews']['items'].length,
                      // itemCount: 2,
                      separatorBuilder: (context, index) => const SizedBox(height: 20),
                      itemBuilder: (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(result.data!['products']['items'][0]['reviews']['items'][index]['nickname'], style: AppStyles.getMediumTextStyle(fontSize: 16)),
                              RatingBar.builder(
                                initialRating: result.data!['products']['items'][0]['reviews']['items'][index]['average_rating'] / 20,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                ignoreGestures: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                                onRatingUpdate: (rating) {
                                  //print(rating);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(result.data!['products']['items'][0]['reviews']['items'][index]['summary'], style: AppStyles.getMediumTextStyle(fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(result.data!['products']['items'][0]['reviews']['items'][index]['text'], style: AppStyles.getRegularTextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
              Center(
                child: InkWell(
                  onTap: () => showReviewDialog(context),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(15),
                    constraints: const BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      // border: Border.all(color: AppColors.dividerColor),
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle, size: 20),
                        const SizedBox(width: 10),
                        Text("Add your review", style: AppStyles.getRegularTextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detailed Description",
              style: AppStyles.getMediumTextStyle(fontSize: 16, color: AppColors.primaryColor),
            ),
            child![0],
            const SizedBox(height: 20),
            Text(
              "Review",
              style: AppStyles.getMediumTextStyle(fontSize: 16, color: AppColors.primaryColor),
            ),
            child![1],
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  String productReviewMetaData = r'''
  query {
    productReviewRatingsMetadata {
      items {
        id
        name
        values {
          value_id
          value
        }
      }
    }
  }''';
  showReviewDialog(context) {
    List<double> ratings = [];
    TextEditingController name = TextEditingController();
    TextEditingController summary = TextEditingController();
    TextEditingController text = TextEditingController();
    String? errorData;
    final formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context3) {
        Size size = MediaQuery.of(context).size;
        return StatefulBuilder(builder: (context2, setState) {
          final client = GraphQLProvider.of(context);
          return GraphQLProvider(
            key: ValueKey<int>(Random(100).nextInt(50)),
            client: client,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Material(
                child: Container(
                  width: size.width * 0.8,
                  // height: size.height * 0.8,
                  constraints: const BoxConstraints(maxHeight: 600, maxWidth: 800),
                  padding: EdgeInsets.symmetric(vertical: AppResponsive.isDesktop(context) ? 20 : 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Query(
                    options: QueryOptions(document: gql(productReviewMetaData)),
                    builder: (result, {fetchMore, refetch}) {
                      if (result.isLoading) {
                        return Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.buttonColor)));
                      }

                      if (ratings.isEmpty) {
                        for (int i = 0; i < result.data!['productReviewRatingsMetadata']['items'].length; i++) {
                          ratings.add(0);
                        }
                      }
                      return Form(
                        key: formKey,
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: AppResponsive.isDesktop(context) ? 40 : 20, vertical: AppResponsive.isDesktop(context) ? 20 : 10),
                          children: [
                            Text("Rate this product", style: AppStyles.getMediumTextStyle(fontSize: 20)),
                            const SizedBox(height: 20),
                            ListView.separated(
                              shrinkWrap: true,
                              itemCount: result.data!['productReviewRatingsMetadata']['items'].length,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                return Wrap(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    // SizedBox(width: 100, child: Text(data['name'], style: AppStyles.getMediumTextStyle(fontSize: 15))),
                                    // const SizedBox(height: 5),
                                    Center(
                                      child: RatingBar.builder(
                                        glow: false,
                                        initialRating: ratings[index],
                                        itemCount: 5,
                                        itemSize: size.width * 0.2 > 50 ? 50 : size.width * 0.2,
                                        minRating: 1,
                                        itemBuilder: (context, index) {
                                          switch (index) {
                                            case 0:
                                              return const Icon(
                                                Icons.sentiment_very_dissatisfied,
                                                color: Colors.red,
                                              );
                                            case 1:
                                              return const Icon(
                                                Icons.sentiment_dissatisfied,
                                                color: Colors.redAccent,
                                              );
                                            case 2:
                                              return const Icon(
                                                Icons.sentiment_neutral,
                                                color: Colors.amber,
                                              );
                                            case 3:
                                              return const Icon(
                                                Icons.sentiment_satisfied,
                                                color: Colors.lightGreen,
                                              );
                                            case 4:
                                              return const Icon(
                                                Icons.sentiment_very_satisfied,
                                                color: Colors.green,
                                              );
                                            default:
                                              return const SizedBox();
                                          }
                                        },
                                        onRatingUpdate: (rating) {
                                          ratings[index] = rating;
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            BuildLoginTextFormField(
                              controller: name,
                              title: 'Name',
                              validator: (value) => value != null && value.isNotEmpty ? null : "Enter name",
                              hintTextStyle: AppStyles.getRegularTextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 20),
                            BuildLoginTextFormField(
                              controller: summary,
                              title: 'Title',
                              validator: (value) => value != null && value.isNotEmpty ? null : "Enter Title",
                              hintTextStyle: AppStyles.getRegularTextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 20),
                            BuildLoginTextFormField(
                              controller: text,
                              title: 'Review',
                              validator: (value) => value != null && value.isNotEmpty ? null : "Enter Review",
                              hintTextStyle: AppStyles.getRegularTextStyle(fontSize: 14),
                              maxLines: 5,
                            ),
                            const SizedBox(height: 20),
                            if (errorData != null) Center(child: Text(errorData!, style: AppStyles.getRegularTextStyle(fontSize: 13, color: Colors.red))),
                            Mutation(
                                options: MutationOptions(
                                  document: gql(ProductApi.createReview),
                                  onCompleted: (data) {
                                    //print(data);
                                    if (data != null) {
                                      Navigator.pop(context2);
                                      showSnackBar(context: context, message: "Review added", backgroundColor: AppColors.buttonColor);
                                    }
                                  },
                                  onError: (error) => print(error),
                                ),
                                // builder: (context) {
                                builder: (runMutation, mResult) {
                                  return TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: AppColors.buttonColor,
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        setState(() => errorData = null);
                                        for (var i in ratings) {
                                          if (i == 0) {
                                            errorData = 'Please fill all the rating fields';
                                            setState(() {});
                                            return;
                                          }
                                        }
                                        List<Map<String, String>> ratingsData = getRatingsData(ratings, result.data!);
                                        //print(ratingsData);
                                        //print(ratings);
                                        //print(widget.sku);
                                        print('grer ${{'name': name.text, 'sku': widget.sku, 'summary': summary.text, 'text': text.text, 'ratings': ratingsData}}');
                                        runMutation({'name': name.text, 'sku': widget.sku, 'summary': summary.text, 'text': text.text, 'ratings': ratingsData});
                                      }
                                    },
                                    child: mResult!.isLoading
                                        ? const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)))
                                        : Text('Add review', style: AppStyles.getMediumTextStyle(fontSize: 14, color: Colors.white)),
                                  );
                                }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  List<Map<String, String>> getRatingsData(List<double> ratings, Map data) {
    List<Map<String, String>> ratingsData = List.generate(ratings.length, (index) => {});
    for (int i = 0; i < ratings.length; i++) {
      int ratingIndex = data['productReviewRatingsMetadata']['items'][i]['values'].indexWhere((value) => value['value'].toString() == ratings[i].round().toString());
      ratingsData[i] = {
        'id': data['productReviewRatingsMetadata']['items'][i]['id'],
        'value_id': data['productReviewRatingsMetadata']['items'][i]['values'][ratingIndex]['value_id']
      };
    }
    //print(jsonEncode(ratingsData));
    return ratingsData;
  }
}

class BuildTitleDetail extends StatelessWidget {
  const BuildTitleDetail({super.key, required this.title, required this.detail});
  final String title;
  final String detail;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.getMediumTextStyle(fontSize: 13, color: AppColors.fontColor),
        ),

        const SizedBox(height: 10),
        HtmlWidget(detail, textStyle: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText))
        // Text(
        //   detail,
        //   style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText),
        // )
      ],
    );
  }
}
