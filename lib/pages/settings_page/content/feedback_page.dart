import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';

class FeedbackPages extends StatelessWidget {
  const FeedbackPages({super.key});

  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDark ? Colors.black : Colors.white.withOpacity(0.95);
    Color titleColor = isDark ? Colors.white.withOpacity(0.7) : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "FeedBack",
          style: AppTextStyles.appTitleStyle.copyWith(color: titleColor),
        ),
      ),
    );
  }
}
