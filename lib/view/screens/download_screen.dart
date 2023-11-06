import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/view/widgets/banner_ad_container.dart';

import '../../controller/downloader_controller.dart';
import '../../models/custom_colors.dart';
import '../widgets/download_text_field.dart';
import '../widgets/quality_table.dart';

class DownloadScreen extends StatelessWidget {
  final DownloaderController downloaderController;
  const DownloadScreen(this.downloaderController, {super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    return Obx(
      () => Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                DownloadTextField(downloaderController),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.blue),
                  onPressed: downloaderController.url.value.isNotEmpty
                      ? downloaderController.convertVideo
                      : null,
                  child: downloaderController.isLoading.isTrue
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : const Text("Convert"),
                ),
                const SizedBox(height: 50),
                if (downloaderController.isInitialized.isTrue) ...[
                  Image.network(
                    "https://img.youtube.com/vi/${downloaderController.video.id}/mqdefault.jpg",
                    width: width,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 7),
                  SizedBox(
                    width: width,
                    child: Text(downloaderController.video.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13)),
                  ),
                  Text(downloaderController.durationText,
                      style: const TextStyle(fontSize: 13)),
                  QualityTable(downloaderController),
                  const SizedBox(height: kBottomNavigationBarHeight + 10),
                ]
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BannerAdContainer(),
          ),
        ],
      ),
    );
  }
}
