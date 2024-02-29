import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/app_responsive.dart';
import '../utilities/utilities.dart';
import '../utilities/widgets/widgets.dart';

// CMS page contact
class ContactView extends StatefulWidget {
  const ContactView({super.key});
  static String route = 'contact';
  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  List<String> addresses = [];
  List<String> phoneNo = [];
  List<String> email = [];

  // Read from the assets/src/contact_info.json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/src/contact_info.json');
    final data = await json.decode(response);
    // addresses = data['address_lines'].map((e) => e.toString()).toList();

    // Address lines
    addresses = List<String>.generate(data['address_lines'].length, (index) => data['address_lines'][index]);
    // Phone numbers
    phoneNo = List<String>.generate(data['phone_no'].length, (index) => data['phone_no'][index]);
    // Emails
    email = List<String>.generate(data['email'].length, (index) => data['email'][index]);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BuildScaffold(
      child: ListView(
        children: [
          Container(
            width: size.width,
            height: size.width * 0.4,
            constraints: const BoxConstraints(maxHeight: 400),
            padding: EdgeInsets.all(size.width * 0.05),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                  'assets/images/build2.png',
                ),
                alignment: Alignment.center,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(AppColors.buttonColor, BlendMode.softLight),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Get in touch\n',
                      style: AppStyles.getMediumTextStyle(fontSize: 20, color: Colors.white),
                    ),
                    // TextSpan(text: title, style:AppStyles. getExtraLightTextStyle(fontSize: 10, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          AppResponsive(
              mobile: Column(
                children: [
                  const SizedBox(height: 20),
                  BuildContact(title: 'Phone', icon: FontAwesomeIcons.phone, details: phoneNo),
                  const SizedBox(height: 20),
                  Divider(height: 1, color: AppColors.dividerColor),
                  const SizedBox(height: 20),
                  BuildContact(title: 'Address', icon: Icons.location_on, details: addresses),
                  const SizedBox(height: 20),
                  Divider(height: 1, color: AppColors.dividerColor),
                  const SizedBox(height: 20),
                  BuildContact(title: 'Email', icon: Icons.email, details: email),
                ],
              ),
              desktop: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildContact(title: 'Phone', icon: FontAwesomeIcons.phone, details: phoneNo),
                          Container(width: 1, color: AppColors.dividerColor, height: 200),
                          BuildContact(title: 'Address', icon: Icons.location_on, details: addresses),
                          Container(width: 1, color: AppColors.dividerColor, height: 200),
                          BuildContact(title: 'Email', icon: Icons.email, details: email),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 50),
          // const BuildContactMessage(),
          // const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class BuildContact extends StatelessWidget {
  const BuildContact({super.key, required this.title, required this.icon, required this.details});
  final String title;
  final IconData icon;
  final List<String> details;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: AppStyles.getSemiBoldTextStyle(fontSize: 20, color: AppColors.fontColor)),
        const SizedBox(height: 15),
        Icon(icon, color: AppColors.buttonColor, size: 20),
        const SizedBox(height: 15),
        Column(
          children: List.generate(
            details.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Text(
                details[index],
                style: AppStyles.getMediumTextStyle(fontSize: 14, color: AppColors.fadedText),
              ),
            ),
          ),
        )
      ],
    );
  }
}

// User form (Note: Only if extension is activated in magento)
class BuildContactMessage extends StatefulWidget {
  const BuildContactMessage({super.key});

  @override
  State<BuildContactMessage> createState() => BuildContacttMessageState();
}

class BuildContacttMessageState extends State<BuildContactMessage> with AutomaticKeepAliveClientMixin {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  bool get wantKeepAlive => true;
  @override
  void dispose() {
    super.dispose();
    fullName.dispose();
    email.dispose();
    phone.dispose();
    company.dispose();
    message.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(size.width * 0.075),
      color: const Color(0x3331aca0),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Send us a message', style: AppStyles.getMediumTextStyle(fontSize: 25, color: AppColors.buttonColor)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: fullName,
                  decoration: InputDecoration(
                    hintStyle: AppStyles.getRegularTextStyle(fontSize: 13),
                    hintText: 'Full Name',
                  ),
                  style: AppStyles.getRegularTextStyle(fontSize: 13),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintStyle: AppStyles.getRegularTextStyle(fontSize: 13),
                    hintText: 'Email',
                  ),
                  style: AppStyles.getRegularTextStyle(fontSize: 13),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: phone,
                  decoration: InputDecoration(
                    hintStyle: AppStyles.getRegularTextStyle(fontSize: 13),
                    hintText: 'Phone',
                  ),
                  style: AppStyles.getRegularTextStyle(fontSize: 13),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: company,
                  decoration: InputDecoration(
                    hintStyle: AppStyles.getRegularTextStyle(fontSize: 13),
                    hintText: 'Company',
                  ),
                  style: AppStyles.getRegularTextStyle(fontSize: 13),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: message,
                  decoration: InputDecoration(
                    hintStyle: AppStyles.getRegularTextStyle(fontSize: 13),
                    hintText: 'Message',
                  ),
                  style: AppStyles.getRegularTextStyle(fontSize: 13),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xff000000),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Enquire Now', style: AppStyles.getSemiBoldTextStyle(fontSize: 15, color: Colors.white)),
                      SvgPicture.asset('assets/svg/arrow_sent.svg'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
