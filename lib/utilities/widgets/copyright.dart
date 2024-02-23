import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities.dart';

// Copyright widget for the footbar
class BuildCopyright extends StatelessWidget {
  const BuildCopyright({super.key, required this.width});
  final double width;
  @override
  Widget build(BuildContext context) {
    return AppResponsive(
        mobile: Column(
          children: [
            Text(
              '© Copyright 2021 Mockup. All Rights Reserved.',
              style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.evenFadedText),
              // softWrap: false,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: width * 0.15,
              // List of all links
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  BuildCopyRightAvatar(
                    width: width,
                    icon: FontAwesomeIcons.facebookF,
                    url: 'https://www.facebook.com/jishnusanju',
                    color: AppColors.fadedContainerColor,
                  ),
                  SizedBox(width: width * 0.01),
                  BuildCopyRightAvatar(
                    width: width,
                    icon: FontAwesomeIcons.twitter,
                    url: 'https://www.facebook.com/jishnusanju',
                    color: AppColors.fadedContainerColor,
                  ),
                  SizedBox(width: width * 0.01),
                  BuildCopyRightAvatar(width: width, icon: FontAwesomeIcons.googlePlusG, url: 'https://www.facebook.com/jishnusanju', color: AppColors.fadedContainerColor),
                  SizedBox(width: width * 0.01),
                  BuildCopyRightAvatar(
                    width: width,
                    icon: FontAwesomeIcons.instagram,
                    url: 'https://www.facebook.com/jishnusanju',
                    color: AppColors.fadedContainerColor,
                  ),
                ],
              ),
            )
          ],
        ),
        tablet: null,
        desktop: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '© Copyright 2021 Mockup. All Rights Reserved.',
              style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.evenFadedText),
              // softWrap: false,
            ),
            SizedBox(
              height: width * 0.15,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  BuildCopyRightAvatar(
                    width: width,
                    icon: FontAwesomeIcons.facebookF,
                    url: 'https://www.facebook.com/jishnusanju',
                    color: AppColors.fadedContainerColor,
                  ),
                  SizedBox(width: width * 0.01),
                  BuildCopyRightAvatar(
                    width: width,
                    icon: FontAwesomeIcons.twitter,
                    url: 'https://www.facebook.com/jishnusanju',
                    color: AppColors.fadedContainerColor,
                  ),
                  SizedBox(width: width * 0.01),
                  BuildCopyRightAvatar(width: width, icon: FontAwesomeIcons.googlePlusG, url: 'https://www.facebook.com/jishnusanju', color: AppColors.fadedContainerColor),
                  SizedBox(width: width * 0.01),
                  BuildCopyRightAvatar(
                    width: width,
                    icon: FontAwesomeIcons.instagram,
                    url: 'https://www.facebook.com/jishnusanju',
                    color: AppColors.fadedContainerColor,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

// Widget to build avatars for a link
class BuildCopyRightAvatar extends StatelessWidget {
  const BuildCopyRightAvatar({super.key, required this.width, required this.icon, required this.url, required this.color});
  final double width;
  final IconData icon;
  final String url;
  final Color color;

  void _launchURL() async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        width * 0.15 > 50 ? 50 : width * 0.15,
      ),
      onTap: _launchURL,
      child: Container(
        width: width * 0.15 > 50 ? 50 : width * 0.15,
        height: width * 0.15 > 50 ? 50 : width * 0.15,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: AppColors.evenFadedText, width: 1),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: FaIcon(
          icon,
          color: AppColors.fadedText,
        ),
      ),
    );
  }
}
