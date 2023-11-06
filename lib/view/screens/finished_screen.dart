import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart';
import 'package:youtube_downloader/controller/finished_videos_controller.dart';

import '../widgets/banner_ad_container.dart';

class FinishedScreen extends StatelessWidget {
  const FinishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FinishedVideosController.to.isLoading.isTrue
            ? const Center(child: CircularProgressIndicator())
            : FinishedVideosController.to.finishedVideos.isEmpty
                ? const Center(
                    child: Text(
                    "You did not download any video yet",
                    style: TextStyle(color: Colors.grey),
                  ))
                : RefreshIndicator(
                    onRefresh: () async {
                      await FinishedVideosController.to.getFinishedVideos();
                    },
                    child: ListView.builder(
                      itemCount:
                          FinishedVideosController.to.finishedVideos.length,
                      itemBuilder: (context, index) {
                        final finishedVideo =
                            FinishedVideosController.to.finishedVideos[index];
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerRight,
                            color: Colors.red.shade900,
                            child: const Icon(
                              FontAwesomeIcons.trashCan,
                              color: Colors.white,
                            ),
                          ),
                          key: UniqueKey(),
                          onDismissed: (details) {
                            FinishedVideosController.to
                                .deleteFile(finishedVideo);
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            leading: Stack(
                              children: [
                                SizedBox(
                                  width: Get.size.width * 0.15,
                                  height: Get.size.width * 0.15,
                                  child: Image.file(finishedVideo.thumbnail,
                                      fit: BoxFit.cover),
                                ),
                                const Positioned(
                                  bottom: 0,
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              basename(finishedVideo.file.path),
                              maxLines: 3,
                              style: const TextStyle(fontSize: 13),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  finishedVideo.createdDate,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  finishedVideo.size,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            onTap: () async {
                              await OpenFile.open(finishedVideo.file.path);
                            },
                          ),
                        );
                      },
                    ),
                  ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: BannerAdContainer(),
        ),
      ],
    );
  }
}
