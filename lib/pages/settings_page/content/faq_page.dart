import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        // leading: IconButton(
        //     onPressed: () {
        //       AppRouter.router.push("/settings");
        //     },
        //     icon: const Icon(Icons.arrow_back),),
        title: Text(
          "FAQ",
          style: AppTextStyles.appTitleStyle,
        ),
      ),
      body: const Center(
        child: Text("FAQ"),
      ),
    );
  }
}
