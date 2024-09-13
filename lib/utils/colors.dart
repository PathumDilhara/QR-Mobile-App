import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color kBlackColor = Color(0xFF000000);
  static Color kSubtitleColor = Colors.grey.withOpacity(0.3);
  static Color kGreyColor = Colors.grey;
  static const Color kWhiteColor = Colors.white;
  static Color kScaffoldBgColorLight = Colors.black.withOpacity(0.05);
  static const Color kSnackBarColor = Color(0xFF470557);
  static Color kSettingsContentsPageBgColor = Colors.white.withOpacity(0.3);
  static Color kLinkColor = Colors.blue;
  static Color kGreenColor = Colors.green;

  // Purple theme colour
  static const Color kMainPurpleColor = Color(0xFFD053F3);
  static const Color kPurpleColor = Colors.purple;

  // // Blue theme color
  // static const Color kMainBlueColor = Colors.blueAccent;
  // static const Color kBlueColor = Colors.blue;

  // Method to get theme-based color (light/dark)
  // text color
  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.7)
        : Colors.black;
  }

  // settings page containers bgf color
  static Color getSettingsContainerBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.withOpacity(0.3)
        : Colors.white;
  }

  // FAQ page panel bg color
  static Color getFAQPanelBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFF2F2F2)
        : const Color(0xFFE6D1F3);
  }
}
