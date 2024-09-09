import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/colors.dart';

class BottomShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.kMainColor.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10); // Adjust blur

    final rect = Rect.fromLTWH(0, size.height, size.width, 50); // Paint shadow below
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
