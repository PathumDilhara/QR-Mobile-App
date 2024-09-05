import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDark ? Colors.black : Colors.white.withOpacity(0.95);
    Color titleColor = isDark ? Colors.white.withOpacity(0.7) : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // automaticallyImplyLeading: false,
        // leading: IconButton(
        //     onPressed: () {
        //       AppRouter.router.push("/settings");
        //     },
        //     icon: const Icon(Icons.arrow_back),),
        title: Text(
          "FAQ",
          style: AppTextStyles.appTitleStyle.copyWith(color: titleColor),
        ),
      ),
      body: const Center(
        child: Text("FAQ"),
      ),
    );
  }
}
