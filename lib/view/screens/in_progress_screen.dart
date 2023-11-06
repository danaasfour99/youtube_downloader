import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:youtube_downloader/controller/downloader_controller.dart';

import '../widgets/banner_ad_container.dart';

class InProgressScreen extends StatelessWidget {
  final DownloaderController downloaderController;
  const InProgressScreen(this.downloaderController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          downloaderController.inProgress.isEmpty
              ? const Center(
                  child: Text(
                  "There is no in progress download",
                  style: TextStyle(color: Colors.grey),
                ))
              : ListView.builder(
                  itemCount: downloaderController.inProgress.length,
                  itemBuilder: (context, index) {
                    final inProgressVideo =
                        downloaderController.inProgress[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      leading: SizedBox(
                        width: Get.size.width * 0.15,
                        height: Get.size.width * 0.15,
                        child: Image.network(
                            "https://img.youtube.com/vi/${inProgressVideo.video!.id}/mqdefault.jpg"),
                      ),
                      title: Text(
                        inProgressVideo.video!.title,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 13),
                      ),
                      trailing: SizedBox(
                        width: 23,
                        child: CircularPercentIndicator(
                          radius: 22.0,
                          lineWidth: 4.0,
                          percent: inProgressVideo.progress.value / 100,
                          center: Text(
                            "${inProgressVideo.progress.value}%",
                            style: const TextStyle(fontSize: 8),
                          ),
                          progressColor: Colors.green,
                        ),
                      ),
                    );
                  },
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
