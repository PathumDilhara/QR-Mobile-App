import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';

class FeedbackPages extends StatelessWidget {
  const FeedbackPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FeedBack",
          style: AppTextStyles.appTitleStyle,
        ),
      ),
    );
  }
}
