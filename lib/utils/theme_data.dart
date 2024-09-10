import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class CustomThemeData {

  static ThemeData lightTheme(BuildContext context) {
    // final Color bgColor = Theme.of(context).brightness == Brightness.dark
    //     ? Colors.black
    //     : AppColors.kScaffoldBgColor;
    return ThemeData(
      scaffoldBackgroundColor: AppColors.kScaffoldBgColor,
      appBarTheme: const AppBarTheme(color: Colors.transparent,scrolledUnderElevation: 0, elevation: 0),
      textTheme: GoogleFonts.dmSansTextTheme(
        Theme.of(context).textTheme,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: AppColors.kMainColor,
      ),
    );
  }

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
        secondary: AppColors.kMainColor,
      ),
    );
  }
}
