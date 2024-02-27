import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/customer_apis.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/state_management/user/user_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/account_sidebar.dart';
import 'package:m2/utilities/widgets/loading_builder.dart';
import 'package:m2/utilities/widgets/scaffold_body.dart';
import 'package:provider/provider.dart';

class AccountInformationView extends StatefulWidget {
  const AccountInformationView({super.key});
  static String route = 'info';
  @override
  State<AccountInformationView> createState() => _AccountInformationViewState();
}

class _AccountInformationViewState extends State<AccountInformationView> {
  Gender? _gender;
  late int genderInt;
  bool isEnabled = false; //Enable editing
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNo = TextEditingController();

  final ScrollController scrollController = ScrollController();

  late UserData userData;

  getData() async {
    fName.text = userData.data.firstname!;
    lName.text = userData.data.lastname!;
    email.text = userData.data.email!;
    _gender = userData.data.gender == 1 ? Gender.male : Gender.female;
    // print(userData.data.toJson());
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) => getData());
  }

  @override
  void didChangeDependencies() {
    userData = Provider.of<UserData>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    fName.dispose();
    lName.dispose();
    email.dispose();
    phoneNo.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BuildScaffold(
      currentIndex: 3,
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
                    child: AccountSideBar(currentPage: AccountInformationView.route),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldColor,
                        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 50, offset: const Offset(0, 10))],
                      ),
                      child: getBody(context, size)),
                ),
              ],
            ),
            mobile: getBody(context, size),
          ),
        );
      }),
    );
  }

  Padding getBody(BuildContext context, Size size) {
    return Padding(
      padding: AppResponsive.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: 60, vertical: 50) : EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text('Account Information', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.primaryColor)),
          ),
          const SizedBox(height: 20),
          TextFormField(
            enabled: isEnabled,
            controller: fName,
            style: AppStyles.getLightTextStyle(fontSize: 17, color: AppColors.fadedText),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
              hintStyle: AppStyles.getLightTextStyle(fontSize: 17, color: AppColors.fadedText),
              hintText: 'First name',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            enabled: isEnabled,
            controller: lName,
            style: AppStyles.getLightTextStyle(fontSize: 17, color: AppColors.fadedText),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
              hintStyle: AppStyles.getLightTextStyle(fontSize: 17, color: AppColors.fadedText),
              hintText: 'Last name',
            ),
          ),
          const SizedBox(height: 20),
          // Wrap(
          //   children: [
          //     SizedBox(
          //       width: 150,
          //       child: ListTile(
          //         onTap: () => setState(() {
          //           if (isEnabled) _gender = Gender.male;
          //         }),
          //         leading: Radio(
          //           toggleable: isEnabled,
          //           value: Gender.male,
          //           groupValue: _gender,
          //           onChanged: (value) => setState(() {
          //             if (isEnabled) _gender = Gender.male;
          //           }),
          //         ),
          //         title: Text('Male', style: AppStyles.getLightTextStyle(fontSize: 16, color: AppColors.fadedText)),
          //       ),
          //     ),
          //     SizedBox(
          //       width: 150,
          //       child: ListTile(
          //         onTap: () => setState(() {
          //           if (isEnabled) _gender = Gender.female;
          //         }),
          //         leading: Radio(
          //           toggleable: isEnabled,
          //           value: Gender.female,
          //           groupValue: _gender,
          //           onChanged: (value) => setState(() {
          //             if (isEnabled) _gender = Gender.female;
          //           }),
          //         ),
          //         title: Text('Female', style: AppStyles.getLightTextStyle(fontSize: 16, color: AppColors.fadedText)),
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 20),
          TextFormField(
            enabled: false,
            controller: email,
            style: AppStyles.getLightTextStyle(fontSize: 17, color: AppColors.fadedText),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
              hintStyle: AppStyles.getLightTextStyle(fontSize: 17, color: AppColors.fadedText),
              hintText: 'Email',
            ),
          ),
          const SizedBox(height: 20),
          // TextFormField(
          //   enabled: false,
          //   controller: phoneNo,
          //   style: AppStyles.getLightTextStyle(fontSize: 17, color: AppColors.fadedText),
          //   keyboardType: TextInputType.name,
          //   textInputAction: TextInputAction.next,
          //   decoration: InputDecoration(
          //     disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
          //     border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
          //     hintStyle: AppStyles.getLightTextStyle(fontSize: 17, color: AppColors.fadedText),
          //     hintText: 'Phone number',
          //   ),
          // ),
          // const SizedBox(height: 20),
          // Edit details and upload to database
          Mutation(
              options: MutationOptions(
                  document: gql(CustomerApis.updateCustomer),
                  onCompleted: (data) {
                    print(data);
                    showSnackBar(context: context, message: "User updated successfully", backgroundColor: AppColors.snackbarSuccessBackgroundColor);
                    userData.getUserData(context);
                  },
                  onError: (error) {
                    print(error);
                  }),
              builder: (RunMutation runMutation, QueryResult? result) {
                return TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: const Size(100, 50),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    if (isEnabled) {
                      runMutation({
                        'input': {
                          'firstname': fName.text,
                          'lastname': lName.text,
                          // 'gender': _gender == Gender.male ? 1 : 2,
                        }
                      });
                    }
                    setState(() => isEnabled = !isEnabled);
                  },
                  child: result!.isLoading
                      ? BuildLoadingWidget(color: AppColors.buttonColor)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: isEnabled
                              ? [
                                  Icon(FontAwesomeIcons.floppyDisk, color: AppColors.primaryColor),
                                  Text('Save', style: AppStyles.getRegularTextStyle(fontSize: 20, color: AppColors.primaryColor))
                                ]
                              : [
                                  Icon(FontAwesomeIcons.penToSquare, color: AppColors.primaryColor),
                                  Text('Edit', style: AppStyles.getRegularTextStyle(fontSize: 20, color: AppColors.primaryColor))
                                ],
                        ),
                );
              })
        ],
      ),
    );
  }
}
