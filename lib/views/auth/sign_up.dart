import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
// import 'package:m2/services/services.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/views/auth/auth.dart';
import 'package:m2/views/auth/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.size}) : super(key: key);
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
  Gender _gender = Gender.male;
  DateFormat dateFormat = DateFormat('MM/dd/yyyy');
  DateTime? selectedDateView;
  DateFormat selectedDateFormat = DateFormat('dd MMM yyyy');
  var selectedDate;
  String? errorData;

  // Pick date for DOB
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateView) {
      setState(() {
        selectedDateView = picked;
        selectedDate = dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText),
          ),
          BuildLoginTextFormField(
            controller: fName,
            title: 'First Name*',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          BuildLoginTextFormField(
            controller: lName,
            title: 'Last Name*',
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: AppColors.buttonColor,
                      ),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        selectedDateView != null ? 'Date of Birth: ${selectedDateFormat.format(selectedDateView!)}' : 'Date of Birth',
                        style: AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.buttonColor),
                      ),
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: [
              SizedBox(
                width: 150,
                child: ListTile(
                  onTap: () => setState(() {
                    _gender = Gender.male;
                  }),
                  leading: Radio(
                    value: Gender.male,
                    groupValue: _gender,
                    onChanged: (value) => setState(() {
                      _gender = Gender.male;
                    }),
                  ),
                  title: Text('Male', style: AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.fadedText)),
                ),
              ),
              SizedBox(
                width: 150,
                child: ListTile(
                  onTap: () => setState(() {
                    // Gender enum for better handling
                    _gender = Gender.female;
                  }),
                  leading: Radio(
                    value: Gender.female,
                    groupValue: _gender,
                    onChanged: (value) => setState(() {
                      // Gender enum for better handling
                      _gender = Gender.female;
                    }),
                  ),
                  title: Text('Female', style: AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.fadedText)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              newsLetters = !newsLetters;
              setState(() {});
            },
            child: Row(children: [
              Checkbox(
                activeColor: AppColors.buttonColor,
                value: newsLetters,
                onChanged: (value) {
                  newsLetters = value!;
                  setState(() {});
                },
              ),
              Text(
                ' Sign Up for Newsletter',
                style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText),
              ),
            ]),
          ),
          const SizedBox(height: 30),
          Text(
            'Sign In Information',
            style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText),
          ),
          const SizedBox(height: 10),
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
          BuildLoginTextFormField(
            controller: cPassword,
            title: 'Confirm Password*',
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          const SizedBox(height: 30),
          // Mutation(
          //   options: MutationOptions(
          //     document: gql(MutationServices.signUp),
          //     // ignore: void_checks
          //     update: (GraphQLDataProxy cache, QueryResult? result) {
          //       return cache;
          //     },
          //     onError: (error) {
          //       errorData = error!.graphqlErrors[0].message;
          //       setState(() {});
          //     },
          //     onCompleted: (dynamic resultData) {
          //       navigate(context, Auth.route);
          //       print('resultData:$resultData');
          //     },
          //   ),
          //   builder: (RunMutation runMutation, QueryResult? result) {
          //     int gender = _gender == Gender.male ? 1 : 2;
          //     return
          TextButton(
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
              // runMutation({
              //   'firstname': fName.text,
              //   'lastname': lName.text,
              //   'email': email.text,
              //   'password': password.text,
              //   'date_of_birth': selectedDate,
              //   'gender': gender,
              //   'is_subscribed': newsLetters,
              // });
            },
            child:
                //  result!.isLoading
                //     ? SizedBox(
                //         height: 25,
                //         width: 25,
                //         child: CircularProgressIndicator(color: AppColors.buttonColor),
                //       )
                // :
                Text(
              'SIGN UP',
              style: AppStyles.getSemiBoldTextStyle(fontSize: 14, color: AppColors.buttonColor),
            ),
          )
          // ;
          //   },
          // )
        ],
      ),
    );
  }
}
