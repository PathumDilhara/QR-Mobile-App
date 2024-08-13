import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_mobile_app/pages/onboarding_screen/onboarding_screens.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/routers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.kWhiteColor,
        appBarTheme: const AppBarTheme(color: AppColors.kWhiteColor),
        textTheme: GoogleFonts.signikaTextTheme(Theme.of(context).textTheme),
      ),
      // home: const OnboardingScreen(),   // no need when we use router
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
// google font style
