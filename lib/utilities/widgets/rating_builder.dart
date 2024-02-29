import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:m2/utilities/utilities.dart';

class BuildRating extends StatelessWidget {
  const BuildRating({super.key, required this.rating, this.noOfReviews});
  final int? rating;
  final int? noOfReviews;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: noOfReviews != null && noOfReviews != 0
          ? <Widget>[
              RatingBar.builder(
                initialRating: rating! / 20,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ignoreGestures: true,
                itemSize: 20,

                // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
              const SizedBox(width: 20),
              Text(
                '$noOfReviews Reviews',
                style: AppStyles.getRegularTextStyle(fontSize: 10, color: AppColors.fadedText),
              ),
            ]
          : <Widget>[
              TextButton(
                onPressed: () {},
                child: Text(
                  'Be the first one to review this product',
                  style: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.fadedText),
                ),
              ),
            ],
    );
  }
}
