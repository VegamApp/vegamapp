import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/customer_apis.dart';

// import 'package:m2/services/services.dart';
import 'package:m2/services/state_management/token/token.dart';

import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/loading_builder.dart';
import 'package:m2/views/auth/forgot_password.dart';
import 'package:m2/views/home/home_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.size});
  final Size size;
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String? errorData;
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    final authToken = Provider.of<AuthToken>(context);
    // final cart = Provider.of<CartData>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Mutation(
        options: MutationOptions(
          document: gql(CustomerApis.signInWithEmail),
          onCompleted: (data) async {
            print(data);
            try {
              authToken.putLoginToken(data!['generateCustomerToken']['token']);
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString('token', authToken.loginToken!);
              // Timer(const Duration(milliseconds: 500), () async {
              // await cart.getCustomerCart(context, authToken);
              context.go(HomeView.route);
              // });
            } catch (e) {
              errorData = "Cannot authenticate";
            }
          },
          onError: (error) {
            try {
              errorData = error?.graphqlErrors[0].message;
              setState(() {});
            } catch (e) {
              print(e);
            }
          },
        ),
        builder: (runMutation, result) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
                validator: validateEmail,
              ),
              const SizedBox(height: 10),
              BuildLoginTextFormField(
                controller: password,
                title: 'Password*',
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validator: (value) => value != null && value.isNotEmpty ? null : "Check password",
                onFieldSubmitted: (value) {
                  setState(() => errorData = null);
                  runMutation({'email': email.text, "password": password.text});
                },
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
                  setState(() => errorData = null);
                  runMutation({'email': email.text, "password": password.text});
                },
                child: result!.isLoading
                    ? BuildLoadingWidget(color: AppColors.buttonColor)
                    : Text(
                        'SIGN IN',
                        style: AppStyles.getSemiBoldTextStyle(fontSize: 14, color: AppColors.buttonColor),
                      ),
              ),

              // ;
              // }),
              const SizedBox(height: 30),
              Center(
                child: InkWell(
                  onTap: () => context.push('/${ForgotPassword.route}'),
                  child: Text(
                    'Forgot Password?',
                    style: AppStyles.getRegularTextStyle(fontSize: 12, color: AppColors.fontColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BuildLoginTextFormField extends StatefulWidget {
  const BuildLoginTextFormField(
      {super.key,
      required this.controller,
      required this.title,
      this.keyboardType,
      this.obscureText,
      this.validator,
      this.hintTextStyle,
      this.maxLines,
      this.textCapitalization,
      this.onFieldSubmitted,
      this.maxLength});
  final TextEditingController controller;
  final String title;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? Function(String? value)? validator;
  final TextStyle? hintTextStyle;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization? textCapitalization;
  final Function(String value)? onFieldSubmitted;
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
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
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
      maxLength: widget.maxLength,
      maxLines: widget.maxLines ?? 1,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
