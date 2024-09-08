import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/widgets/setting_content_widget.dart';

import '../../provider/settings_provider.dart';
import '../../utils/routers.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.7)
        : Colors.black;
    final Color titleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey
        : Colors.grey;
    final Color bgColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.withOpacity(0.3)
        : Colors.white;
    // final Color dividerColor = Theme.of(context).brightness == Brightness.dark
    //     ? Colors.grey.withOpacity(0.3)
    //     : Colors.grey.withOpacity(0.3);

    const double adHeight = 30;

    return Scaffold(
      // backgroundColor: AppColors.kScaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 76,
          top: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  print("clicked add free");
                },
                style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.1),),
                  elevation: const WidgetStatePropertyAll(5),
                  minimumSize: const WidgetStatePropertyAll(
                    Size(120, 50),
                  ),
                  backgroundColor: const WidgetStatePropertyAll(AppColors.kMainColor),
                ),
                child: const Center(
                  child: Text(
                    "Add free",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                "General settings",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  // height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: bgColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SettingsContentWidget(title: "Dark Mode"),
                          const Spacer(),
                          Switch(
                            value: settingsProvider.isDarkMode,
                            activeColor: AppColors.kWhiteColor.withOpacity(0.7),
                            activeTrackColor: AppColors.kMainColor,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey.withOpacity(0.3),
                            onChanged: (value) {
                              settingsProvider.toggleTheme();
                            },
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      Row(
                        children: [
                          const SettingsContentWidget(
                              title: "History Auto save"),
                          const Spacer(),
                          Switch(
                            value: settingsProvider.isHistorySaving,
                            activeColor: AppColors.kWhiteColor.withOpacity(0.7),
                            activeTrackColor: AppColors.kMainColor,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey.withOpacity(0.3),
                            onChanged: (value) {
                              settingsProvider.toggleHistorySaving();
                            },
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      Row(
                        children: [
                          const SettingsContentWidget(
                              title: "Enable notifications"),
                          const Spacer(),
                          Switch(
                            value: settingsProvider.notificationEnabled,
                            activeColor: AppColors.kWhiteColor.withOpacity(0.7),
                            activeTrackColor: AppColors.kMainColor,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey.withOpacity(0.3),
                            onChanged: (value) {
                              settingsProvider.toggleNotificationsShowing();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              // Help area
              Text(
                "Help",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: bgColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AppRouter.router.push("/faq");
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          child: const SettingsContentWidget(title: "FAQ"),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppRouter.router.push("/feedback");
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          child: const SettingsContentWidget(title: "Feedback"),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppRouter.router.push("/privacy_policy");
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          child: const SettingsContentWidget(
                              title: "Privacy policy"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              // More info area
              Text(
                "More info",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: bgColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AppRouter.router.push("/update");
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          child: const SettingsContentWidget(
                              title: "Check for updates"),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Row(
                            children: [
                              const SettingsContentWidget(title: "Version"),
                              const Spacer(),
                              Text(
                                "10.01.5",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Positioned(
// left: 0,
// right: 0,
// bottom: kBottomNavigationBarHeight + 20,
// child: Padding(
// padding: const EdgeInsets.symmetric(horizontal: 10.0),
// child: Container(
// width: double.infinity,
// height: 100,
// color: AppColors.kMainColor.withOpacity(0.3),
// child: const Center(
// child: Text(
// "Advertisement here",
// style: TextStyle(fontSize: 20, color: Colors.white),
// ),
// ),
// ),
// ),
// ),
