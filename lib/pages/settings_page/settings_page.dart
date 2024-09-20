import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/widgets/setting_content_widget.dart';

import '../../provider/settings_provider.dart';
import '../../utils/routers.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-3940256099942544/6300978111", // Replace with actual ID for release
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print("Ad loaded");
          setState(() {});
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print("Ad failed to load: $error");
          ad.dispose();
        },
        onAdOpened: (Ad ad) {
          print("Ad opened");
        },
      ),
      request: const AdRequest(),
    )..load();

    _getVersionInfo();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  String _version = "";


  // // Banner ads
  // BannerAd _bannerAd = new BannerAd(
  //   size: AdSize.banner,
  //   adUnitId: "ca-app-pub-3940256099942544/6300978111",
  //   listener: BannerAdListener(
  //     onAdLoaded: (Ad ad) {
  //       print("Ad loaded ##############################");
  //     },
  //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //       print("Ad failed load ##############################");
  //       ad.dispose();
  //     },
  //     onAdOpened: (Ad ad) {
  //       print("Ad opened ##############################");
  //     },
  //   ),
  //   request: const AdRequest(),
  // );
  //
  // String _version = "";
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _getVersionInfo();
  // }

  Future<void> _getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;

    setState(() {
      _version = version;

    });
  }

  @override
  Widget build(BuildContext context) {

    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextColor(context),
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
                height: 30,
              ),
              _customElevatedButton(),
              // const SizedBox(
              //   height: 50,
              // ),
              Text(
                "General settings",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kGreyColor,
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
                    color: AppColors.getSettingsContainerBgColor(context),
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
                            activeTrackColor: AppColors.kMainPurpleColor,
                            inactiveThumbColor: AppColors.kGreyColor,
                            inactiveTrackColor: AppColors.kGreyColor.withOpacity(0.3),
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
                            activeTrackColor: AppColors.kMainPurpleColor,
                            inactiveThumbColor: AppColors.kGreyColor,
                            inactiveTrackColor: AppColors.kGreyColor.withOpacity(0.3),
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
                            activeTrackColor: AppColors.kMainPurpleColor,
                            inactiveThumbColor: AppColors.kGreyColor,
                            inactiveTrackColor: AppColors.kGreyColor.withOpacity(0.3),
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
                  color: AppColors.kGreyColor,
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
                    color: AppColors.getSettingsContainerBgColor(context),
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
                  color: AppColors.kGreyColor,
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
                    color: AppColors.getSettingsContainerBgColor(context),
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
                                _version,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.kWhiteColor.withOpacity(0.7)
                                      : AppColors.kBlackColor,
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
              // SizedBox(
              //   height: 50,
              //   width: double.infinity,
              //   // color: Colors.black,
              //   child: AdWidget(
              //     ad: _bannerAd..load(),
              //     key: UniqueKey(),
              //   ),
              // ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: _bannerAd != null
                    ? AdWidget(ad: _bannerAd!)
                    : const SizedBox(), // If ad is null, show an empty container
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customElevatedButton(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: ElevatedButton(
        onPressed: () {
          // print("clicked add free");
        },
        style: ButtonStyle(
          overlayColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.1),),
          elevation: const WidgetStatePropertyAll(5),
          minimumSize: const WidgetStatePropertyAll(
            Size(120, 50),
          ),
          backgroundColor: const WidgetStatePropertyAll(AppColors.kMainPurpleColor),
        ),
        child: const Center(
          child: Text(
            "Ads free",
            style: TextStyle(
              fontSize: 28,
              color: AppColors.kWhiteColor,
              fontWeight: FontWeight.bold,
            ),
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
