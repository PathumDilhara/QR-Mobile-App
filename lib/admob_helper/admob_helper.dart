import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobHelper {
  // Banner ads
  static String get bannerUnit => "ca-app-pub-3940256099942544/6300978111";

  // Interstitial ads
  InterstitialAd? _interstitialAd;
  int numOfAttemptLoad = 0;

  // Reward ads
  RewardedAd? _rewardedAd;

  static initialization() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  // Banner ads
  static BannerAd getBannerAd() {
    BannerAd _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId:
          "ca-app-pub-3940256099942544/6300978111", // Replace with actual ID for release
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

  // Interstitial ads
  void createInterstitialAds() {
    InterstitialAd.load(
      adUnitId:
          "ca-app-pub-3940256099942544/1033173712", // Replace with actual ID for release
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

  // Interstitial ads
  void loadInterstitialAds() {
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
        createInterstitialAds();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // Reward ads
  void loadRewardAds() {
    RewardedAd.load(
      adUnitId:
          "ca-app-pub-3940256099942544/5224354917", // Replace with actual ID for release
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          this._rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          // loadRewardAds();
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
