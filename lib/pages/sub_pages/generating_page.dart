import 'package:flutter/material.dart';

import '../../utils/text_styles.dart';

class QRGeneratingPage extends StatelessWidget {
  const QRGeneratingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Text(
        "Generate",
        style: AppTextStyles.appSubtitleStyle,
      ),)
    );
  }
}
