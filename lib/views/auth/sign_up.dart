import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:m2/services/api_services/customer_apis.dart';
// import 'package:m2/services/services.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/loading_builder.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/auth/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.size});
  final Size size;
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  bool newsLetters = false;
  bool remoteAssistance = false;
  // Gender? _gender;
  // DateFormat dateFormat = DateFormat('MM/dd/yyyy');
  DateTime? selectedDateView;
  DateFormat selectedDateFormat = DateFormat('dd MMM yyyy');
  String? selectedDate;
  String? errorData;

  final _formKey = GlobalKey<FormState>();

  // Pick date for DOB
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked =
  //       await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900, 8), lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDateView) {
  //     setState(() {
  //       selectedDateView = picked;
  //       selectedDate = dateFormat.format(picked);
  //     });
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    cPassword.dispose();
    fName.dispose();
    lName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Personal Information',
              style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText),
            ),
            BuildLoginTextFormField(
              controller: fName,
              title: 'First Name*',
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              validator: (value) => value != null && value.length > 2 ? null : "Enter a valid name",
            ),
            const SizedBox(height: 10),
            BuildLoginTextFormField(
              controller: lName,
              title: 'Last Name*',
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.name,
              validator: (value) => value != null && value.length > 2 ? null : "Enter a valid name",
            ),
            // const SizedBox(height: 10),
            // GestureDetector(
            //   onTap: () => _selectDate(context),
            //   child: Container(
            //       height: 50,
            //       padding: const EdgeInsets.all(10).copyWith(left: 0),
            //       decoration: BoxDecoration(
            //           color: Colors.white,
            //           border: Border(
            //             bottom: BorderSide(
            //               width: 1.5,
            //               color: AppColors.buttonColor,
            //             ),
            //           )),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           FittedBox(
            //             fit: BoxFit.fitWidth,
            //             child: Text(
            //               selectedDateView != null ? 'Date of Birth: ${selectedDateFormat.format(selectedDateView!)}' : 'Date of Birth',
            //               style: AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.buttonColor),
            //             ),
            //           ),
            //         ],
            //       )),
            // ),
            // const SizedBox(height: 10),
            // Wrap(
            //   children: [
            //     SizedBox(
            //       width: 150,
            //       child: ListTile(
            //         onTap: () => setState(() {
            //           _gender = Gender.male;
            //         }),
            //         leading: Radio(
            //           value: Gender.male,
            //           groupValue: _gender,
            //           onChanged: (value) => setState(() {
            //             _gender = Gender.male;
            //           }),
            //         ),
            //         title: Text('Male', style: AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.fadedText)),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 150,
            //       child: ListTile(
            //         onTap: () => setState(() {
            //           // Gender enum for better handling
            //           _gender = Gender.female;
            //         }),
            //         leading: Radio(
            //           value: Gender.female,
            //           groupValue: _gender,
            //           onChanged: (value) => setState(() {
            //             // Gender enum for better handling
            //             _gender = Gender.female;
            //           }),
            //         ),
            //         title: Text('Female', style: AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.fadedText)),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 20),

            CheckboxListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: newsLetters,
              onChanged: (value) {
                newsLetters = value!;
                setState(() {});
              },
              title: Text(
                'Sign Up for Newsletter',
                style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: remoteAssistance,
              onChanged: (value) {
                remoteAssistance = value!;
                setState(() {});
              },
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Allow remote shopping assistance',
                      style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Tooltip(
                    richMessage: WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Text(
                          "This allows merchants to \"see what you see\" and take actions on your behalf in order to provide better assistance.",
                          style: AppStyles.getMediumTextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    child: const Icon(Icons.info_outline, size: 20),
                  ),
                ],
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 20),
            Text(
              'Sign In Information',
              style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText),
            ),
            const SizedBox(height: 10),
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
              validator: (value) => value != null && value.isNotEmpty ? null : "Enter password",
            ),
            const SizedBox(height: 10),
            BuildLoginTextFormField(
              controller: cPassword,
              title: 'Confirm Password*',
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              validator: (value) => value == password.text ? null : "Passwords do not match",
            ),

            const SizedBox(height: 20),
            if (errorData != null) Text(errorData!, style: AppStyles.getRegularTextStyle(fontSize: 12, color: Colors.red)),
            const SizedBox(height: 10),

            Mutation(
                options: MutationOptions(
                  document: gql(CustomerApis.signUpWithEmail),
                  onCompleted: (data) {
                    print(data);
                    if (data != null) {
                      context.pop();
                      context.go('/${Auth.route}');
                      showSnackBar(
                        context: context,
                        message: "Account created. Please sign in to continue",
                        backgroundColor: AppColors.snackbarSuccessBackgroundColor,
                      );
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
                  return TextButton(
                    style: TextButton.styleFrom(
                        fixedSize: Size(widget.size.width, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(33.0),
                          side: BorderSide(width: 3.0, color: AppColors.buttonColor),
                        )),
                    onPressed: () {
                      setState(() {
                        errorData = null;
                      });

                      if (_formKey.currentState!.validate()) {
                        runMutation({
                          'firstname': fName.text,
                          'lastname': lName.text,
                          'email': email.text,
                          'password': password.text,
                          'is_subscribed': newsLetters,
                        });
                      }
                    },
                    child: result!.isLoading
                        ? BuildLoadingWidget(color: AppColors.buttonColor)
                        : Text(
                            'SIGN UP',
                            style: AppStyles.getSemiBoldTextStyle(fontSize: 14, color: AppColors.buttonColor),
                          ),
                  );
                })
            // ;
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
