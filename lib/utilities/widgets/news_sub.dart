import 'package:flutter/material.dart';
import 'package:m2/services/api_services/api_services.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/services/state_management/user/user_data.dart';
import 'package:provider/provider.dart';
import '../utilities.dart';

class NewsSub extends StatefulWidget {
  const NewsSub({super.key});

  @override
  State<NewsSub> createState() => _NewsSubState();
}

class _NewsSubState extends State<NewsSub> {
  TextEditingController email = TextEditingController();
  Widget buttonText = Text('Send', style: AppStyles.getRegularTextStyle(fontSize: 15, color: Colors.white));
  Widget buttonLoading = const CircularProgressIndicator(semanticsLabel: "Loading", color: Colors.white);
  late Widget buttonLabel;

  sendEmail() async {
    setState(() {
      buttonLabel = buttonLoading;
    });
    bool i = await ApiServices().sendNewsLetter('email');
    if (i) {
      buttonLabel = const Icon(Icons.check, color: Colors.white);
    } else {
      buttonLabel = const Icon(Icons.close, color: Colors.white);
    }
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      buttonLabel = buttonText;
    });
  }

  @override
  void initState() {
    super.initState();
    buttonLabel = buttonText;
  }

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Newsletter subscription',
          style: AppStyles.getBoldTextStyle(fontSize: 20, color: AppColors.primaryColor),
          softWrap: false,
        ),
        const SizedBox(height: 20),
        Container(
          // width: widget.width,
          height: 50,
          // padding: EdgeInsets.only(left: widget.width * 0.05),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(41.0),
            border: Border.all(width: 1.0, color: AppColors.evenFadedText),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 70,
                // color: Colors.green,
                // height: 50,
                // width: widget.width * 0.75,
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    hintText: 'Email',
                    hintStyle: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.evenFadedText),
                  ),
                ),
              ),
              Expanded(
                flex: 30,
                child: TextButton(
                  onPressed: sendEmail,
                  style: TextButton.styleFrom(
                    minimumSize: Size.infinite,
                    backgroundColor: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(41),
                    ),
                  ),
                  child: buttonLabel,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  String mutationStirng = """mutation {
            subscribeEmailToNewsletter(
              email: "email@example.com"
            ) {
              status
            }
          }""";
}
