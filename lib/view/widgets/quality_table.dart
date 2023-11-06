import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/controller/downloader_controller.dart';

import '../../controller/ad_mob_controller.dart';
import '../../models/custom_colors.dart';

class QualityTable extends StatelessWidget {
  final DownloaderController downloaderController;
  const QualityTable(this.downloaderController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Table(
          border: TableBorder.all(color: CustomColors.silver),
          children: downloaderController.info.map((item) {
            return TableRow(children: [
              _subTitle(item.qualityText),
              _subTitle(item.size),
              if (item.id == -1)
                _subTitle('Status')
              else
                item.isDownloading.isTrue
                    ? Center(
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 16,
                          width: 16,
                          child: const CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.blue)),
                        ),
                      )
                    : item.isCompleted.isTrue
                        ? const IconButton(
                            splashRadius: 24,
                            onPressed: null,
                            icon: Icon(Icons.done, color: CustomColors.blue),
                          )
                        : item.quality >= 720
                            ? IconButton(
                                splashRadius: 24,
                                onPressed: () {
                                  AdMobController.to.showRewardedAd(
                                      onFinished: () {
                                    downloaderController.downloadVideo(item);
                                  });
                                },
                                icon: const Icon(FontAwesomeIcons.film,
                                    size: 20, color: CustomColors.blue),
                              )
                            : IconButton(
                                splashRadius: 24,
                                onPressed: () {
                                  downloaderController.downloadVideo(item);
                                  final AdMobController adMobController =
                                      Get.find();
                                  adMobController.showInterstitialAd();
                                },
                                icon: const Icon(Icons.download,
                                    color: CustomColors.blue),
                              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _subTitle(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(text,
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
    );
  }
}
