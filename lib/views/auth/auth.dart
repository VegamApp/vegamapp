import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/scaffold_body.dart';
import 'package:m2/views/auth/sign_in.dart';
import 'package:m2/views/auth/sign_up.dart';
// import 'package:m2/views/home.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});
  static String route = 'auth';
  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BuildScaffold(
      // bottomNavBarVisible: true,
      currentIndex: 3,
      child: ListView(
        children: [
          const Divider(height: 1),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: EdgeInsets.all(size.width * 0.05 > 40 ? 40 : size.width * 0.05),
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05 > 50 ? 50 : size.width * 0.05, vertical: 20),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: AppColors.shadowColor),
                          borderRadius: BorderRadius.circular(size.width * 0.05 > 30 ? 30 : size.width * 0.05),
                        ),
                        child: StatefulBuilder(builder: (context, builder) {
                          return Column(
                            // shrinkWrap: true,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Show sign in and sign up tabs
                              TabBar(
                                controller: _tabController,
                                indicatorWeight: 5,
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorColor: AppColors.buttonColor,
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                                onTap: (index) => setState(() {}),
                                tabs: [
                                  Text(
                                    'Sign In',
                                    style: AppStyles.getBoldTextStyle(
                                      fontSize: 20,
                                      color: _tabController.index == 0 ? AppColors.fontColor : AppColors.kPrimaryColor,
                                    ),
                                  ),
                                  Text(
                                    'Sign Up',
                                    style: AppStyles.getBoldTextStyle(
                                      fontSize: 20,
                                      color: _tabController.index == 1 ? AppColors.fontColor : AppColors.kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              // Animate between sign in page and sign up page
                              AnimatedSwitcher(
                                transitionBuilder: (child, animation) => SlideTransition(
                                  position: Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
                                  child: child,
                                ),
                                duration: const Duration(milliseconds: 200),
                                child: _tabController.index == 0 ? SignIn(size: size) : SignUp(size: size),
                              )
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 30),
                      // Center(
                      //   child: Text(
                      //     'Login with social',
                      //     style: AppStyles.getRegularTextStyle(fontSize: 12, color: AppColors.fadedText),
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     BuildLoginSocialButton(
                      //       size: size,
                      //       onPressed: () {},
                      //       icon: FontAwesomeIcons.facebookF,
                      //       color: AppColors.facebookBlue,
                      //     ),
                      //     BuildLoginSocialButton(
                      //       size: size,
                      //       onPressed: () {},
                      //       icon: FontAwesomeIcons.googlePlusG,
                      //       color: AppColors.googleRed,
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          // FootBar(width: size.width, screenWidth: size.width)
        ],
      ),
    );
  }
}

class BuildLoginSocialButton extends StatelessWidget {
  const BuildLoginSocialButton({super.key, required this.size, required this.onPressed, required this.icon, required this.color});

  final Size size;
  final Function()? onPressed;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          fixedSize: Size(size.width * 0.425, size.width * 0.1),
          maximumSize: const Size(200, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.1),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: Colors.white,
              size: size.width * 0.03 > 16 ? 16 : size.width * 0.03,
            ),
            SizedBox(width: size.width * 0.05 > 20 ? 20 : size.width * 0.05),
            Text(
              'Log in',
              style: AppStyles.getRegularTextStyle(fontSize: size.width * 0.03 > 16 ? 16 : size.width * 0.03, color: Colors.white),
            )
          ],
        ));
  }
}
