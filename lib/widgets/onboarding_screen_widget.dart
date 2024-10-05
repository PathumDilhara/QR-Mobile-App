import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';

class OnboardingScreenWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;

  const OnboardingScreenWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imageUrl,
          width: MediaQuery.of(context).size.width * 0.9,
          fit: BoxFit.cover,
        ),
        Text(title,
            textAlign: TextAlign.center,
            style: AppTextStyles.appTitleStyle.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.kGreyColor.withOpacity(0.6),
          ),
        ),
        const SizedBox(
          height: 80,
        ),
      ],
    );
  }
}
