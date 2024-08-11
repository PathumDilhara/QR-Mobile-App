import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';

class QRScanningPage extends StatelessWidget {
  const QRScanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Scan",
          style: AppTextStyles.appSubtitleStyle,
        ),
      ),
    );
  }
}
