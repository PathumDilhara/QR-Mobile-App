import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_mobile_app/pages/settings_page/content/faq_page.dart';
import 'package:qr_mobile_app/pages/settings_page/content/feedback_page.dart';
import 'package:qr_mobile_app/pages/home_page/home_page.dart';
import 'package:qr_mobile_app/pages/home_page/sub_pages/scan_result_page.dart';
import 'package:qr_mobile_app/pages/onboarding_screen/onboarding_screens.dart';
import 'package:qr_mobile_app/pages/settings_page/content/privacy_policy_page.dart';
import 'package:qr_mobile_app/pages/settings_page/settings_page.dart';
import 'package:qr_mobile_app/user_services/shared_preferences_services/user_services.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    initialLocation: "/onboarding_screen",
    redirect: (context, state) async {
      bool loginState = await UserServices.checkLoginState();

      // If user is not logged in and trying to access any page(home) other than onboarding screens,
      // redirect to onboarding screen
      if (!loginState && state.matchedLocation != "/onboarding_screen") {
        return "/onboarding_screen";
      }

      // If user is logged in and trying to access onboarding screens, redirect to home
      if (loginState && state.matchedLocation == "/onboarding_screen") {
        return "/home";
      }

      // Allow navigation to the requested page
      // If none of the above conditions are met, the user can navigate to the requested page.
      return null;
    },
    routes: [
      // Onboarding screens
      GoRoute(
        name: "onboarding_screen",
        path: "/onboarding_screen",
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Home page
      GoRoute(
        name: "home",
        path: "/home",
        builder: (context, state) => const HomePage(),
      ),

      // Scan result page
      // GoRoute(
      //   name: "scan result",
      //   path: "/scan_result",
      //   builder: (context, state) {
      //     final result = state.extra as String;
      //     return ScanResultPage(
      //       result: result,
      //     );
      //   },
      // ),

      // Settings page
      GoRoute(
        name: "settings page",
        path: "/settings",
        builder: (context, state) => const SettingsPage(),
      ),

      // FAQ page
      GoRoute(
        name: "faq page",
        path: "/faq",
        builder: (context, state) => const FAQPage(),
      ),

      // Feedback page
      GoRoute(
        name: "feedback page",
        path: "/feedback",
        builder: (context, state) => const FeedbackPages(),
      ),

      // Privacy policy page
      GoRoute(
        name: "privacy policy page",
        path: "/privacy_policy",
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
    ],
  );
}
