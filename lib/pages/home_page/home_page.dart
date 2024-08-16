import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';
import 'sub_pages/generating_page.dart';
import 'sub_pages/scanning_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    PersistentTabController persistentTabController = PersistentTabController();

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //       onPressed: () {
      //         AppRouter.router.go("/onboarding_screen");
      //       },
      //       icon: const Icon(
      //         Icons.arrow_back,
      //       )),
      // ),
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
      body: SafeArea(
        child: PersistentTabView(
          context,
          controller: persistentTabController,
          screens: const [

            QRGeneratingPage(),
            QRScanningPage(),
          ],
          items: _navBarItems(),
          handleAndroidBackButtonPress: true,
          hideNavigationBarWhenKeyboardAppears: true,
          padding: const EdgeInsets.all(10),
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
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.fadeIn,
            ),
          ),
          //confineToSafeArea: true,
          navBarHeight: 60,
          navBarStyle: NavBarStyle.style10,
        ),
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.qr_code_scanner_outlined,
          size: 30,
        ),
        title: "Scan",
        textStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        activeColorPrimary: AppColors.kMainColor, // for icon
        activeColorSecondary: AppColors.kWhiteColor, // for text
        inactiveColorPrimary: AppColors.kBlackColor, // for when not selected
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.qr_code_outlined,
          size: 30,
        ),
        title: "Generate",
        textStyle: AppTextStyles.appSubtitleStyle.copyWith(fontSize: 50),
        activeColorPrimary: AppColors.kMainColor,
        activeColorSecondary: AppColors.kWhiteColor,
        inactiveColorPrimary: AppColors.kBlackColor,
      ),
    ];
  }
}
