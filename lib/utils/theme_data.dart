import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class CustomThemeData {

  // Light theme
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.kScaffoldBgColorLight,
      appBarTheme: const AppBarTheme(color: Colors.transparent,scrolledUnderElevation: 0, elevation: 0),
      textTheme: GoogleFonts.dmSansTextTheme(
        Theme.of(context).textTheme,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: AppColors.kMainPurpleColor,
      ),
    );
  }

  // Dark theme
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black.withOpacity(0.5),
      appBarTheme: const AppBarTheme(color: Colors.black),
      textTheme: GoogleFonts.dmSansTextTheme(
        Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.grey,
            ),
      ),
      colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
        secondary: AppColors.kMainPurpleColor,
      ),
    );
  }
}
