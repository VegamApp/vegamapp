import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/views/auth/sign_in.dart';
// import 'package:m2/views/home.dart';
// import '../../services/services.dart';
import '../../utilities/utilities.dart';

// Password reset page
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String? errorData;

  double _textSize(String text, TextStyle style) {
    // Get width of a given text
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  bool emailSent = false;

  String title = 'Forgot Your Password?';
  TextStyle titleStyle() => TextStyle(
        fontSize: 20,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w700,
        color: AppColors.fontColor,
      );
  TextEditingController email = TextEditingController();
  TextEditingController token = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(size.width * 0.05 > 40 ? 40 : size.width * 0.05),
              margin: EdgeInsets.all(size.width * 0.05),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.shadowColor),
                borderRadius: BorderRadius.circular(size.width * 0.05 > 20 ? 20 : size.width * 0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Your Password?',
                    style: titleStyle(),
                  ),
                  // Underline
                  Container(
                    width: _textSize(title, titleStyle()),
                    color: AppColors.buttonColor,
                    height: 5,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Please enter your email address below to receive a password reset link.',
                    style: AppStyles.getRegularTextStyle(fontSize: 12, color: AppColors.fadedText),
                  ),
                  const SizedBox(height: 10),
                  BuildLoginTextFormField(
                    controller: email,
                    title: 'Email *',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  if (emailSent)
                    Column(
                      children: [
                        BuildLoginTextFormField(
                          controller: token,
                          title: 'Please type the letters and numbers sent to your email *',
                          keyboardType: TextInputType.none,
                        ),
                        const SizedBox(height: 10),
                        BuildLoginTextFormField(
                          controller: password,
                          title: 'Enter new password',
                          keyboardType: TextInputType.none,
                        ),
                        const SizedBox(height: 10),
                        BuildLoginTextFormField(
                          controller: confPassword,
                          title: 'Confirm password',
                          keyboardType: TextInputType.none,
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (errorData != null) Text(errorData!, style: AppStyles.getRegularTextStyle(fontSize: 12, color: Colors.red)),
                  const SizedBox(height: 40),
                  // Mutation(
                  //     options: MutationOptions(
                  //       document: gql(emailSent ? MutationServices.passwordReset : MutationServices.requestPasswordResetEmail),
                  //       onCompleted: (result) {
                  //         if (result != null) {
                  //           try {
                  //             print('result $result');
                  //             errorData = 'An email with a password reset token has been sent to your email';
                  //             emailSent = true;
                  //             setState(() {});
                  //             // Navigator.pushAndRemoveUntil(
                  //             //     context, PageTransition(child: const Home(), type: PageTransitionType.fade), (route) => false);
                  //           } catch (e) {
                  //             debugPrint(e.toString());
                  //           }
                  //         }
                  //       },
                  //       onError: (error) {
                  //         print(error);
                  //         errorData = error!.graphqlErrors[0].message;
                  //         setState(() {});
                  //       },
                  //     ),
                  //     builder: (RunMutation runMutation, QueryResult? queryResult) {
                  //       return
                  TextButton(
                    style: TextButton.styleFrom(
                        fixedSize: Size(size.width, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(33.0),
                          side: BorderSide(width: 3.0, color: AppColors.buttonColor),
                        )),
                    onPressed: () {
                      setState(() {
                        errorData = null;
                      });
                      // if (!emailSent) {
                      //   runMutation({'email': email.text});
                      // } else {
                      //   if (password.text == confPassword.text) {
                      //     runMutation({'email': email.text, 'token': token.text, 'password': password.text});
                      //   } else {
                      //     errorData = 'Check password';
                      //   }
                      // }
                    },
                    child:
                        //  queryResult!.isLoading
                        //     ? SizedBox(
                        //         height: 25,
                        //         width: 25,
                        //         child: CircularProgressIndicator(color: AppColors.buttonColor),
                        //       )
                        //     :
                        Text(
                      !emailSent ? 'Get reset password token' : 'RESET PASSWORD',
                      style: AppStyles.getSemiBoldTextStyle(fontSize: 14, color: AppColors.buttonColor),
                      textAlign: TextAlign.center,
                    ),
                  )
                  // ;
                  // }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // FootBar(width: size.width, screenWidth: size.width)
        ],
      ),
    );
  }
}
