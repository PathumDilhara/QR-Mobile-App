import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/widgets/setting_widget.dart';

import '../../provider/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.7)
        : Colors.black;
    final Color titleColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.kMainColor
        : AppColors.kMainColor;
    final Color bgColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.withOpacity(0.3)
        : Colors.white;
    final Color dividerColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.withOpacity(0.3)
        : Colors.grey.withOpacity(0.6);
    return Scaffold(
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
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 76,
          top: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "General settings",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
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
                      color: dividerColor,
                    ),
                    Row(
                      children: [
                        const SettingsContentWidget(title: "History Auto save"),
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
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Help",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: bgColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SettingsContentWidget(title: "Dark mode"),
                    Divider(
                      color: dividerColor,
                    ),
                    const SettingsContentWidget(title: "Dark mode"),
                    Divider(
                      color: dividerColor,
                    ),
                    const SettingsContentWidget(title: "Dark mode"),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: bgColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
