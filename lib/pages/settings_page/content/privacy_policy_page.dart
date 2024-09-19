import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/text_styles.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDark
        ? AppColors.kWhiteColor.withOpacity(0.11)
        : AppColors.kWhiteColor.withOpacity(0.95);
    Color titleColor = isDark ? AppColors.kWhiteColor.withOpacity(0.7) : AppColors.kBlackColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "privacy policy",
          style: AppTextStyles.appTitleStyle.copyWith(color: titleColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 16.0),
          customText(
            "Introduction",
            "This Privacy Policy explains how we collect, use, and share your personal information when you use our app.",
            titleColor,
          ),
          customText(
            "Data Collection",
            "We collect personal data such as your name, email address, and usage data to improve our app.",
            titleColor,
          ),
          customText(
            "Data Usage",
            "The data we collect is used to provide and improve our services, personalize your experience, and for analytics.",
            titleColor,
          ),
          customText(
            "Third-Party Services",
            "We do not use third-party services in our app. Your data is not shared with or accessed by external providers.",
            titleColor,
          ),
          customText(
            "Data Retention",
            "We retain your data for as long as necessary to provide our services or as required by law.",
            titleColor,
          ),
          customText(
            "Data Security",
            "We use encryption and secure storage methods to protect your data.",
            titleColor,
          ),
          customText(
            "User Rights",
            "You have the right to access, modify, or delete your personal data at any time.",
            titleColor,
          ),
          customText(
            "Changes to this Policy",
            "We may update this Privacy Policy from time to time. Any changes will be notified through the app.",
            titleColor,
          ),
          // customText(
          //   "Contact Us",
          //   //"If you have any questions about this Privacy Policy, you can contact us at: support@example.com",
          //   "https://flutter.dev",
          //   titleColor,
          //   isLink: true,
          //   link: "https://flutter.dev",
          // ),
        ],
      ),
    );
  }

  Widget customText(String title, String content, Color titleColor,
      {bool isLink = false, String? link}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 10),
        isLink
            ? GestureDetector(
                onTap: () async {
                  // print("*****************clicked");
                  final String url = link!;
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.kLinkColor, // Link color
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            : Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
        const SizedBox(height: 16),
      ],
    );
  }
}
