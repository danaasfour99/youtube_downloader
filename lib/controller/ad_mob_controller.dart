import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../helpers/ad_mob_service.dart';
import '../helpers/app_lifecycle_rector.dart';

class AdMobController extends GetxController {
  static AdMobController get to => Get.find<AdMobController>();

  BannerAd? bannerAd;
  AppOpenAd? _appOpenAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isShowingAd = false;
  bool _isFirstTime = true;
  bool bannerAdIsLoaded = false;

  bool get isAppOpenAdAvailable => _appOpenAd != null;
  bool get isInterstitialAdAvailable => _interstitialAd != null;
  bool get isRewardedAdAvailable => _rewardedAd != null;
  bool get isBannerAdAvailable => bannerAd != null;

  late AppLifecycleReactor _appLifecycleReactor;

  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  void createBannerAd() {
    bannerAd = null;
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdMobService.bannerAdInitId,
        listener: BannerAdListener(onAdLoaded: (ad) {
          bannerAdIsLoaded = true;
        }, onAdClosed: (ad) {
          debugPrint('$BannerAd onAdClosed.');
        }, onAdFailedToLoad: (ad, e) {
          debugPrint('$BannerAd failedToLoad: $e');
          ad.dispose();
        }),
        request: const AdRequest())
      ..load();
  }

  _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (_) => _interstitialAd = null,
        ));
  }

  void _loadOnAppAd() async {
    AppOpenAd.load(
      adUnitId: AdMobService.openAdUnitId,
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
          if (_isFirstTime) {
            showAppOpenAd();
            _isFirstTime = false;
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
        },
      ),
      request: const AdRequest(),
    );
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdMobService.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  showInterstitialAd() {
    if (isInterstitialAdAvailable) {
      _interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
      });
    }
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void onInit() async {
    _appLifecycleReactor =
        AppLifecycleReactor(showAdIfAvailable: showAppOpenAd);
    _appLifecycleReactor.listenToAppStateChanges();
    _loadOnAppAd();
    createBannerAd();
    _createInterstitialAd();
    _createRewardedAd();
    super.onInit();
  }

  void showAppOpenAd() {
    if (!isAppOpenAdAvailable) {
      debugPrint('Tried to show ad before available.');
      _loadOnAppAd();
      return;
    }
    if (_isShowingAd) {
      debugPrint('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      debugPrint('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      _loadOnAppAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        debugPrint('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _loadOnAppAd();
      },
    );
    _appOpenAd!.show();
  }

  void showRewardedAd({required Function() onFinished}) {
    if (_rewardedAd == null) {
      _createRewardedAd();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        _createRewardedAd();
      },
    );
    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      if (reward.amount > 0) {
        onFinished();
      }
    });
    _rewardedAd = null;
  }
}
