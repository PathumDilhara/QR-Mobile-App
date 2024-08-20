import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:qr_mobile_app/pages/history/history_page.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import '../settings_page/settings_page.dart';
import 'sub_pages/generating_page.dart';
import 'sub_pages/scanning_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    PersistentTabController persistentTabController = PersistentTabController();

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     UserServices.clearSavedLoginState();
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text("Login state cleared"),
      //       ),
      //     );
      //   },
      //   child: const Text("Clear"),
      // ),
      body: PersistentTabView(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: NavBarDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.white,
          Theme.of(context).brightness == Brightness.dark
              ? Colors.transparent
              : Colors.white,
            ],
          ),
        ),
        context,
        controller: persistentTabController,
        screens: const [
          HistoryPage(),
          QRScanningPage(),
          QRGeneratingPage(),
          SettingsPage(),
        ],
        items: _navBarItems(context),
        handleAndroidBackButtonPress: true,
        hideNavigationBarWhenKeyboardAppears: true,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: Colors.white,
        isVisible: true,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            duration: Duration(
              milliseconds: 300,
            ),
            screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
          ),
        ),
        //confineToSafeArea: true,
        navBarHeight: 65,
        navBarStyle: NavBarStyle.style10,
      ),
    );
  }

  // Persistent nav bar item
  List<PersistentBottomNavBarItem> _navBarItems(BuildContext context) {
    final inactiveColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.kWhiteColor.withOpacity(0.7)
        : AppColors.kBlackColor;
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.qr_code_scanner_outlined,
          size: 30,
        ),
        title: "Scan",
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        activeColorPrimary: AppColors.kMainColor, // for icon
        activeColorSecondary: AppColors.kWhiteColor, // for text
        inactiveColorPrimary: inactiveColor, // for when not selected
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.qr_code_outlined,
          size: 30,
        ),
        title: "Generate",
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        activeColorPrimary: AppColors.kMainColor,
        activeColorSecondary: AppColors.kWhiteColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.history,
          size: 30,
        ),
        title: "History",
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        activeColorPrimary: AppColors.kMainColor, // for icon
        activeColorSecondary: AppColors.kWhiteColor, // for text
        inactiveColorPrimary: inactiveColor, // for when not selected
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.settings,
          size: 30,
        ),
        title: "Settings",
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        activeColorPrimary: AppColors.kMainColor, // for icon
        activeColorSecondary: AppColors.kWhiteColor, // for text
        inactiveColorPrimary: inactiveColor, // for when not selected
      ),
    ];
  }
}
