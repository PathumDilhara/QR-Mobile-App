import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_mobile_app/pages/home_page/home_page.dart';
import 'package:qr_mobile_app/pages/onboarding_screen/onboarding_screens.dart';
import 'package:qr_mobile_app/user_services/user_services.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    initialLocation: "/onboarding_screen",
    redirect: (context, state) async{
      bool loginState = await UserServices.checkLoginState();

      // If user is not logged in and trying to access any page(home) other than onboarding screens,
      // redirect to onboarding screen
      if(!loginState && state.matchedLocation != "/onboarding_screen"){
        return "/onboarding_screen";
      }

      // If user is logged in and trying to access onboarding screens, redirect to home
      if (loginState && state.matchedLocation == "/onboarding_screen"){
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
    ],
  );
}
