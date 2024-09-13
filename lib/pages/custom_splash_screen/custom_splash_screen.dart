import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_mobile_app/utils/colors.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Simulate loading (e.g., data loading, initialization)
    await Future.delayed(const Duration(seconds: 1)); // Replace with your actual loading logic
    // Navigate to the main app
    GoRouter.of(context).go('/home'); // Replace '/home' with the appropriate route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/flutter.png', // Replace with your image path
              width: 150, // Adjust size as needed
              height: 150,
            ),
          ),
           Positioned(
             left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.05,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.white,
                color: AppColors.kMainPurpleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
