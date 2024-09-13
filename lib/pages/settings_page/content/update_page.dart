import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../../utils/colors.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  AppUpdateInfo? _updateInfo;
  bool _isUpdateAvailable = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

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
      await InAppUpdate.startFlexibleUpdate();
      // Optionally, you might want to handle the update completion here
    } catch (err) {
      setState(() {
        _isUpdating = false; // Reset the state if the update fails
      });
      debugPrint(
        "Error during update: ${err.toString()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor =
        isDark ? AppColors.kBlackColor : AppColors.kWhiteColor.withOpacity(0.95);
    Color titleColor = isDark ? AppColors.kWhiteColor.withOpacity(0.7) : AppColors.kBlackColor;
    Color buttonColor = isDark ? AppColors.kGreyColor.withOpacity(0.3) : AppColors.kGreyColor.withOpacity(0.8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: Text(
        //   "Update page",
        //   style: AppTextStyles.appTitleStyle,
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/qrc.png", width: 100, fit: BoxFit.cover,),
            Text(
              "Update your \napplication to the \nlatest version",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 10,),
            _isUpdateAvailable ? Text(
              "This update includes improvements to the QR scanning and generating features, enhancing performance and user experience.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: titleColor.withOpacity(0.6),
              ),
            ):
            const SizedBox(),
            const SizedBox(height: 20),
            _isUpdateAvailable
                ? _isUpdating
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                          _customElevatedButton(
                            "Update now",
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
                          "Up to date",
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
          Size(400, 60),
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
