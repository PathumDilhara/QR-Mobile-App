import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_mobile_app/pages/onboarding_screen/onboarding_screens.dart';
import 'package:qr_mobile_app/utils/colors.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.kWhiteColor,
        appBarTheme: const AppBarTheme(color: AppColors.kWhiteColor),
        textTheme: GoogleFonts.signikaTextTheme(Theme.of(context).textTheme),
      ),
      home: const OnboardingScreen(),
    );
  }
}

// flutter pub add go_router
// flutter pub add google_fonts
// flutter pub add shared_preferences
// flutter pub add persistent_bottom_nav_bar
// flutter pub add smooth_page_indicator

// improvements

// page transition improvements
// google fon style
