import 'package:flutter/material.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/models/footer_button_model.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/copyright.dart';
import 'package:m2/utilities/widgets/news_sub.dart';
import 'package:m2/utilities/widgets/stamp_widget.dart';
import 'package:m2/views/home/home_view.dart';
import 'package:page_transition/page_transition.dart';

// Build footbar widget for all pages

class FootBar extends StatefulWidget {
  const FootBar({Key? key, required this.width, required this.screenWidth}) : super(key: key);
  final double width;
  final double screenWidth;
  @override
  State<FootBar> createState() => _FootBarState();
}

class _FootBarState extends State<FootBar> {
  late List<Widget> children;
  // Common widget in both mobile and web view
  List<Widget> getChildren(double size) {
    List<Widget> children = [
      Divider(height: 2, color: AppColors.evenFadedText),
      StampContainer(width: widget.screenWidth),
      LogoContainer(width: widget.width),
      ContactContainer(width: widget.width),
      Padding(
        padding: EdgeInsets.all(size * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewsSub(),
            const SizedBox(height: 30),
            BuildColumnText(
              title: 'Information',
              list: [
                FooterModel(
                  title: 'Complaints',
                  // navigationChild: const ExamplePage(),
                ),
                FooterModel(
                  title: 'About Us',
                  // navigationChild: const AboutPage(),
                ),
                FooterModel(
                  title: 'Contact Us',
                  // navigationChild: const ContactUs(),
                ),
                FooterModel(
                  title: "Chairman's Message",
                  // navigationChild: const ExamplePage(),
                ),
                FooterModel(
                  title: 'Our Stores',
                  // navigationChild: const BlogList(),
                ),
              ],
            ),
            const SizedBox(height: 30),
            BuildColumnText(
              title: 'My Account',
              list: [
                FooterModel(
                  title: 'Compare List',
                  // navigationChild: const ExamplePage(),
                ),
                FooterModel(
                  title: 'Privacy Policy',
                  // navigationChild: const PrivacyPolicy(),
                ),
                FooterModel(
                  title: 'Terms and Conditions',
                  // navigationChild: const ExamplePage(),
                ),
                FooterModel(
                  title: "Refund and Return Policy",
                  // navigationChild: const ExamplePage(),
                ),
              ],
            ),
            const SizedBox(height: 30),
            BuildColumnText(
              title: 'Payment & Shipping',
              list: [
                FooterModel(
                  title: 'Terms of use',
                  // navigationChild: const ExamplePage(),
                ),
                FooterModel(
                  title: 'Payment Methods',
                  // navigationChild: const ExamplePage(),
                ),
                FooterModel(
                  title: 'Location to ship',
                  // navigationChild: const ExamplePage(),
                ),
                FooterModel(
                  title: "Estimated Delivery Time",
                  // navigationChild: const ExamplePage(),
                ),
              ],
            ),
            const SizedBox(height: 30),
            BuildPaymentMethodList(),
          ],
        ),
      ),
      Divider(height: 2, color: AppColors.evenFadedText),
      Container(padding: EdgeInsets.all(size * 0.05), alignment: Alignment.center, child: BuildCopyright(width: widget.width)),
    ];
    return children;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppResponsive(
      desktop: getDesktopChildren(),
      mobile: Container(color: AppColors.fadedContainerColor, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: getChildren(widget.screenWidth))),
      tablet: Container(color: AppColors.fadedContainerColor, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: getChildren(widget.screenWidth))),
    );
  }

  Container getDesktopChildren() {
    return Container(
      color: AppColors.fadedContainerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 2, color: AppColors.evenFadedText),
          StampContainer(width: widget.screenWidth),
          LogoContainer(width: widget.width),
          DesktopContactContainer(width: widget.width),
          Divider(height: 2, color: AppColors.evenFadedText),
          Container(
            width: widget.screenWidth,
            padding: EdgeInsets.all(widget.width * 0.075),
            child: BuildCopyright(width: widget.width),
          ),
        ],
      ),
    );
  }
}

class DesktopContactContainer extends StatelessWidget {
  const DesktopContactContainer({Key? key, required this.width}) : super(key: key);
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints(maxWidth: width * 0.6),
      padding: EdgeInsets.symmetric(horizontal: width * 0.075, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ContactText(title: 'ADDRESS:', subtitle: '1234 Street Name, City, England'),
                    const SizedBox(height: 30),
                    ContactText(title: 'EMAIL:', subtitle: 'mail@example.com'),
                  ],
                ),
              ),
              Expanded(
                flex: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContactText(title: 'PHONE:', subtitle: '(123) 456-7890'),
                    const SizedBox(height: 30),
                    ContactText(title: 'WORKING DAYS/HOURS:', subtitle: 'Mon - Sun / 9:00 AM - 8:00 PM'),
                  ],
                ),
              ),
              Expanded(flex: 30, child: NewsSub()),
              Spacer(flex: 20),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 25,
                child: BuildColumnText(
                  title: 'Information',
                  list: [
                    FooterModel(
                      title: 'Complaints',
                      // navigationChild: const ExamplePage(),
                    ),
                    FooterModel(
                      title: 'About Us',
                      // navigationChild: const AboutPage(),
                    ),
                    FooterModel(
                      title: 'Contact Us',
                      // navigationChild: const ContactUs(),
                    ),
                    FooterModel(
                      title: "Chairman's Message",
                      // navigationChild: const ExamplePage(),
                    ),
                    FooterModel(
                      title: 'Our Stores',
                      // navigationChild: const BlogList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 25,
                child: BuildColumnText(
                  title: 'My Account',
                  list: [
                    FooterModel(
                      title: 'Compare List',
                      // navigationChild: const ExamplePage(),
                    ),
                    FooterModel(
                      title: 'Privacy Policy',
                      // navigationChild: const PrivacyPolicy(),
                    ),
                    FooterModel(
                      title: 'Terms and Conditions',
                      // navigationChild: const ExamplePage(),
                    ),
                    FooterModel(
                      title: "Refund and Return Policy",
                      // navigationChild: const ExamplePage(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 25,
                child: BuildColumnText(
                  title: 'Payment & Shipping',
                  list: [
                    FooterModel(
                      title: 'Terms of use',
                      // navigationChild: const ExamplePage(),
                    ),
                    FooterModel(
                      title: 'Payment Methods',
                      // navigationChild: const ExamplePage(),
                    ),
                    FooterModel(
                      title: 'Location to ship',
                      // navigationChild: const ExamplePage(),
                    ),
                    FooterModel(
                      title: "Estimated Delivery Time",
                      // navigationChild: const ExamplePage(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 25,
                child: BuildPaymentMethodList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget to display contact information
class ContactContainer extends StatelessWidget {
  const ContactContainer({Key? key, required this.width}) : super(key: key);
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width < 1100 ? width : 1100,
      padding: EdgeInsets.all(width * 0.075),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          ContactText(title: 'ADDRESS:', subtitle: '1234 Street Name, City, England'),
          const SizedBox(height: 50),
          ContactText(title: 'EMAIL:', subtitle: 'mail@example.com'),
          const SizedBox(height: 50),
          ContactText(title: 'PHONE:', subtitle: '(123) 456-7890'),
          const SizedBox(height: 50),
          ContactText(title: 'WORKING DAYS/HOURS:', subtitle: 'Mon - Sun / 9:00 AM - 8:00 PM'),
        ],
      ),
    );
  }
}

// widget to display app logo
class LogoContainer extends StatelessWidget {
  const LogoContainer({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: width * 0.075),
      alignment: Alignment.centerLeft,
      child: Image.asset(logoUrl),
    );
  }
}

//  Sub widget of contact display with type and detail
class ContactText extends StatelessWidget {
  const ContactText({Key? key, required this.title, required this.subtitle}) : super(key: key);
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.getBoldTextStyle(fontSize: 18, color: AppColors.fontColor),
        ),
        Text(
          subtitle,
          style: AppStyles.getRegularTextStyle(fontSize: 16, color: AppColors.fadedText),
        ),
      ],
    );
  }
}

// Build a no of text and their navigator
class BuildColumnText extends StatelessWidget {
  const BuildColumnText({Key? key, required this.title, required this.list}) : super(key: key);
  final List<FooterModel> list;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width,
      // color: AppColors.fadedContainerColor,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              Text(title, style: AppStyles.getBoldTextStyle(fontSize: 18, color: AppColors.fontColor)),
            ] +
            List.generate(
              list.length,
              (index) => Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () => Navigator.push(context, PageTransition(child: list[index].navigationChild ?? HomeView(), type: PageTransitionType.fade)),
                  child: Text(
                    list[index].title,
                    style: AppStyles.getRegularTextStyle(fontSize: 16, color: AppColors.evenFadedText),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}

// Build the payment method listing
class BuildPaymentMethodList extends StatelessWidget {
  const BuildPaymentMethodList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Payment method", style: AppStyles.getBoldTextStyle(fontSize: 18, color: AppColors.fontColor)),
        const SizedBox(height: 20),
        Center(child: Image.asset('assets/images/payment.png')),
      ],
    );
  }
}
