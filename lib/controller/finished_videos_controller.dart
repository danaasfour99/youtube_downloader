import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/finished_video.dart';

class FinishedVideosController extends GetxController {
  static FinishedVideosController get to => Get.find();
  RxBool isLoading = false.obs;
  RxList<FinishedVideo> finishedVideos = <FinishedVideo>[].obs;

  getFinishedVideos() async {
    List<FinishedVideo> finishedVideos = [];

    final Directory directory =
        Directory('/storage/emulated/0/Download/YoutubeDownloader');
    if (!directory.existsSync()) {
      this.finishedVideos.value = [];
      this.finishedVideos.refresh();
      return;
    }
    for (final fileSystem in directory.listSync()) {
      final file = File(fileSystem.path);

      finishedVideos.insert(
          0,
          FinishedVideo(
            file: file,
            thumbnail: await _generateThumbnail(file),
            size: await getFileSize(fileSystem.path),
            createdDate:
                "${DateFormat.yMMMd().format(file.lastModifiedSync())} ,${DateFormat.jm().format(file.lastModifiedSync())}",
          ));
    }
    this.finishedVideos.assignAll(finishedVideos);
    this.finishedVideos.refresh();
  }

  Future<String> getFileSize(String filepath) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  Future<File> _generateThumbnail(File file) async {
    final String? path = await VideoThumbnail.thumbnailFile(
      video: file.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 50,
      quality: 100,
    );
    return File(path ?? "");
  }

  @override
  void onInit() async {
    isLoading.value = true;
    await getFinishedVideos();
    isLoading.value = false;
    super.onInit();
  }

  deleteFile(FinishedVideo finishedVideo) {
    finishedVideo.file.deleteSync();
    finishedVideos
        .removeWhere((element) => element.file.path == finishedVideo.file.path);
    getFinishedVideos();
  }
}
