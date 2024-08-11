import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';

class RoundedCustomButton extends StatelessWidget {
  final bool isLastPage;
  const RoundedCustomButton({
    super.key,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.kMainColor,
      ),
      child: Center(
        child: Text(
          isLastPage ? "Get start" : "Next",
          style: AppTextStyles.appTitleStyle
              .copyWith(color: AppColors.kWhiteColor),
        ),
      ),
    );
  }
}
