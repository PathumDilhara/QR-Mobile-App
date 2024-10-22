import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

//  the in_app_update package works with Google Play Store services to facilitate
//  in-app updates for Android apps. Here’s a breakdown of how it integrates with
//  Play Store services.

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  AppUpdateInfo? _updateInfo;
  bool _isUpdateAvailable = false;
  bool _isUpdating = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkForUpdate();
  // }

  // Checks if a new update is available
  Future<void> _checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        setState(() {
          _updateInfo = updateInfo;
          _isUpdateAvailable = true;
        });
      }
    } catch (err) {
      // Log error in a more descriptive way
      debugPrint("Error checking for updates: ${err.toString()}");
    }
  }

  // Starts the update process
  Future<void> _startUpdate() async {
    setState(() {
      _isUpdating = true;
    });
    try {
      await InAppUpdate.performImmediateUpdate();
      // Optionally, you might want to handle the update completion here
    } catch (err) {
      setState(() {
        _isUpdating = false; // Reset the state if the update fails
      });
      // debugPrint(
      //   "Error during update: ${err.toString()}",
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text(
            "Failed to check for updates. Please try again later.",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDark
        ? AppColors.kBlackColor
        : AppColors.kWhiteColor.withOpacity(0.95);
    Color titleColor =
        isDark ? AppColors.kWhiteColor.withOpacity(0.7) : AppColors.kBlackColor;
    Color buttonColor = isDark
        ? AppColors.kGreyColor.withOpacity(0.3)
        : AppColors.kGreyColor.withOpacity(0.8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "App Update",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextColor(context),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _checkForUpdate(),
        builder: (context, snapshot) {
          bool _isLoading = snapshot.connectionState == ConnectionState.waiting;
          bool _hasError = snapshot.hasError;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  isDark
                      ? "assets/images/qr_vault-removebg-preview_dark.png"
                      : "assets/images/qr_vault-removebg-preview.png",//
                  width: 100,
                  fit: BoxFit.cover,
                ),
                Text(
                  _isLoading
                      ? "Checking for updates..."
                      : _hasError
                          ? "Error checking for updates"
                          : (_isUpdateAvailable
                              ? "Update your \napplication to the \nlatest version"
                              : "You’re using the \nlatest version."),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _isUpdateAvailable
                    ? Text(
                        "This update includes improvements to the QR scanning and generating features, enhancing performance and user experience.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: titleColor.withOpacity(0.6),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 20),
                _isUpdateAvailable
                    ? Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                          _customElevatedButton(
                            _isUpdating ? "Updating..." : "Install Update",
                            AppColors.kMainPurpleColor,
                            _startUpdate,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                          Center(
                            child: _customElevatedButton(
                              _isLoading
                                  ? "Checking for updates..."
                                  : _hasError
                                      ? "Error checking for updates"
                                      : "No Update Available",
                              buttonColor,
                              () {},
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _customElevatedButton(
      String title, Color buttonBgColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(
          Colors.white.withOpacity(0.1),
        ),
        elevation: const WidgetStatePropertyAll(5),
        maximumSize: const WidgetStatePropertyAll(
          Size(350, 55),
        ),
        backgroundColor: WidgetStatePropertyAll(buttonBgColor),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.kWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
