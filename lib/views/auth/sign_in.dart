import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/main.dart';

// import 'package:m2/services/services.dart';
import 'package:m2/services/state_management/token/token.dart';

import 'package:m2/utilities/utilities.dart';
import 'package:m2/views/auth/forgot_password.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key, required this.size}) : super(key: key);
  final Size size;
  @override
  State<SignIn> createState() => _SignInState();
}

enum Gender { male, female }

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String? errorData;
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registered Customers',
            style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText),
          ),
          const SizedBox(height: 10),
          Text(
            'If you have an account, sign in with your email address.',
            style: AppStyles.getRegularTextStyle(fontSize: 12, color: AppColors.fadedText),
          ),
          const SizedBox(height: 20),
          BuildLoginTextFormField(
            controller: email,
            title: 'Email*',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          BuildLoginTextFormField(
            controller: password,
            title: 'Password*',
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          const SizedBox(height: 10),
          if (errorData != null) Text(errorData!, style: AppStyles.getRegularTextStyle(fontSize: 12, color: Colors.red)),
          // const SizedBox(height: 10),
          const SizedBox(height: 30),

          TextButton(
            style: TextButton.styleFrom(
                fixedSize: Size(widget.size.width, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(33.0),
                  side: BorderSide(width: 3.0, color: AppColors.buttonColor),
                )),
            onPressed: () async {
              setState(() {
                errorData = null;
              });
            },
            child: Text(
              'SIGN IN',
              style: AppStyles.getSemiBoldTextStyle(fontSize: 14, color: AppColors.buttonColor),
            ),
          ),
          // ;
          // }),
          const SizedBox(height: 30),
          Center(
            child: InkWell(
              onTap: () => Navigator.push(context, PageTransition(child: const ForgotPassword(), type: PageTransitionType.fade)),
              child: Text(
                'ForgotPassword ?',
                style: AppStyles.getRegularTextStyle(fontSize: 12, color: AppColors.fontColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildLoginTextFormField extends StatefulWidget {
  const BuildLoginTextFormField(
      {Key? key,
      required this.controller,
      required this.title,
      this.keyboardType,
      this.obscureText,
      this.validator,
      this.hintTextStyle,
      this.maxLines})
      : super(key: key);
  final TextEditingController controller;
  final String title;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final TextStyle? hintTextStyle;
  final int? maxLines;
  @override
  State<BuildLoginTextFormField> createState() => _BuildLoginTextFormFieldState();
}

class _BuildLoginTextFormFieldState extends State<BuildLoginTextFormField> {
  bool obscureText = false;
  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: obscureText,
      style: AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.buttonColor),
      validator: widget.validator,
      decoration: InputDecoration(
        suffix: widget.obscureText != null
            ? InkWell(
                onTap: () => setState(() {
                      obscureText = !obscureText;
                    }),
                child: Icon(obscureText ? Icons.visibility : Icons.visibility_off, color: AppColors.buttonColor))
            : null,
        focusColor: AppColors.buttonColor,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.buttonColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.buttonColor),
        ),
        hintText: widget.title,
        hintStyle: widget.hintTextStyle ?? AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.buttonColor),
      ),
      maxLength: widget.maxLines ?? 1,
    );
  }
}
