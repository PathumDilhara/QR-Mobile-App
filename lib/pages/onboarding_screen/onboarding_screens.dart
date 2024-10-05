import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/colors.dart';
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
                  title: "Welcome to QR Vault",
                  imageUrl: "assets/images/logo2.png",
                  description:
                      "Securely create, scan, and store QR codes and barcodes in one place. Your ultimate vault for all things QR!",
                ),
                OnboardingScreenWidget(
                  title: "QR Scanning Made Easy",
                  imageUrl: "assets/images/logo2.png",
                  description:
                      "Effortlessly scan any QR code or barcode with precision and speed. Access information instantly with QR Vault.",
                ),
                OnboardingScreenWidget(
                  title: "Generate Custom QR Codes",
                  imageUrl: "assets/images/logo2.png",
                  description:
                      "Create personalized QR codes for websites, contact info, and more. QR Vault gives you the power to generate with ease.",
                ),
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
                    dotWidth: 10,
                    dotHeight: 10,
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
