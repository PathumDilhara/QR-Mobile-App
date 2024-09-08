import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';

import '../user_services/shared_preferences_services/user_services.dart';
import '../utils/routers.dart';

class RoundedCustomButton extends StatelessWidget {
  final bool isLastPage;
  final PageController pageController;
  const RoundedCustomButton({
    super.key,
    required this.isLastPage,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!isLastPage) {
          pageController.animateToPage(
            pageController.page!.toInt() +
                1, // pageController.page is double ---> int
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else if (isLastPage) {
          await UserServices.storeLoginState("LoggedIn");
          // bool loginState = await UserServices.checkLoginState();
          // print(loginState);
          AppRouter.router.push("/home");
        }
      },
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.1)),
        minimumSize: const WidgetStatePropertyAll(
          Size(double.infinity, 50),
        ),
        backgroundColor: const WidgetStatePropertyAll(AppColors.kMainColor),
      ),
      child: Center(
        child: Text(
          isLastPage ? "Get start" : "Next",
          style: AppTextStyles.appTitleStyle.copyWith(
            color: AppColors.kWhiteColor,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
