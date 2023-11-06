import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:youtube_downloader/controller/ad_mob_controller.dart';

class BannerAdContainer extends StatelessWidget {
  const BannerAdContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final BannerAd? bannerAd = AdMobController.to.bannerAd;
    return AdMobController.to.bannerAdIsLoaded && bannerAd != null
        ? Container(
            width: Get.width,
            margin:
                const EdgeInsets.only(bottom: kBottomNavigationBarHeight - 10),
            height: 52,
            child: AdWidget(ad: bannerAd),
          )
        : const SizedBox();
  }
}
