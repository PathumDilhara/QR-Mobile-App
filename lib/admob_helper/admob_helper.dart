import 'package:google_mobile_ads/google_mobile_ads.dart';

// id : ca-app-pub-6164977547035716~7865252074
// banner ad : ca-app-pub-6164977547035716/4582877954
// interstitial : ca-app-pub-6164977547035716/5704387930
// rewarded : ca-app-pub-6164977547035716/4630183252

class AdmobHelper {
  // Banner ads
  static String get bannerUnit => "ca-app-pub-6164977547035716/4582877954";

  // Interstitial ads
  InterstitialAd? _interstitialAd;
  int numOfAttemptLoad = 0;

  // Reward ads
  RewardedAd? _rewardedAd;

  static initialization() async {
    await MobileAds.instance.initialize();
  }

  // Banner ads
  static BannerAd getBannerAd() {
    BannerAd _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId:
          "ca-app-pub-6164977547035716/4582877954", // Replace with actual ID for release
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print("Ad loaded");
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

    return _bannerAd;
  }

  // Interstitial ads creating
  void createInterstitialAds() {
    InterstitialAd.load(
      adUnitId:
          "ca-app-pub-6164977547035716/5704387930",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          numOfAttemptLoad = 0;
        },
        onAdFailedToLoad: (error) {
          numOfAttemptLoad++;
          _interstitialAd = null;

          if (numOfAttemptLoad <= 2) {
            createInterstitialAds();
          }
        },
      ),
    );
  }

  // Interstitial ads loading
  Future<void> loadInterstitialAds() async{
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print("Ad onAdShowedFullScreen");
      },
      onAdDismissedFullScreenContent: (ad) {
        print("Ad disposed");
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print("$ad onAdFailed $error");
        ad.dispose();
        createInterstitialAds(); // Load a new ad
      },
    );
    await _interstitialAd!.show();
    _interstitialAd = null;
  }

  // Reward ads
  void loadRewardAds() {
    RewardedAd.load(
      adUnitId:
          "ca-app-pub-6164977547035716/4630183252", // Replace with actual ID for release
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          // Retry loading the ad if it fails
          loadRewardAds();
        },
      ),
    );
  }

  void showRewardAds() {
    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        print("Reward Earned is ${reward.amount}");
      },
    );
    _rewardedAd!.fullScreenContentCallback  = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {

      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
      },
      onAdImpression: (ad) {
        print("$ad impression occurred");
      },
    );
  }
}
