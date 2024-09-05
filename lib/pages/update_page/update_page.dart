import 'package:flutter/material.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor =
        isDark ? Colors.black : Colors.white.withOpacity(0.95);
    Color titleColor = isDark ? Colors.white.withOpacity(0.7) : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Update page"),
      ),
    );
  }
}
