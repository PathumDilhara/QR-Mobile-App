import 'package:flutter/material.dart';
import 'package:qr_mobile_app/user_services/shared_preferences_services/user_services.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/routers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widgets/onboarding_screen_widget.dart';
import '../../widgets/rounded_custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isLastPage = false;
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  isLastPage = index ==
                      2; // check where we are, if in last page index (2)
                });
              },
              children: const [
                OnboardingScreenWidget(
                  title: "QR Vault",
                  imageUrl: "assets/images/logo2.png",
                  description:
                      "This app is made to create and scan any QR and Barcode",
                ),
                OnboardingScreenWidget(
                  title: "QR Scanning",
                  imageUrl: "assets/images/logo2.png",
                  description:
                      "This app is made to create and scan any QR and Barcode",
                ),
                OnboardingScreenWidget(
                  title: "QR Generating",
                  imageUrl: "assets/images/logo2.png",
                  description:
                      "This app is made to create and scan any QR and Barcode",
                )
              ],
            ),
            // Smooth page indicator
            Container(
              alignment: const Alignment(0, 0.65),
              child: SmoothPageIndicator(
                controller: pageController,
                count: 3,
                effect: ExpandingDotsEffect(
                    expansionFactor: 2.5,
                    offset: 10,
                    spacing: 10,
                    radius: 100,
                    dotWidth: 12,
                    dotHeight: 12,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1,
                    dotColor: AppColors.kSubtitleColor.withOpacity(0.1),
                    activeDotColor: AppColors.kMainPurpleColor),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: RoundedCustomButton(
                isLastPage: isLastPage,
                pageController: pageController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
