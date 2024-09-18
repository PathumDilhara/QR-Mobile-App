import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/colors.dart';

class AppTextStyles {
  // Title Style
  static TextStyle appTitleStyle = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.kBlackColor,
  );

  // Subtitle Style
  static TextStyle appSubtitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.kSubtitleColor,
  );

  // Button Style
  static TextStyle appButtonTextStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.kWhiteColor,
  );

  // Description Style
  static TextStyle appDescriptionTextStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.kBlackColor,
  );
}
