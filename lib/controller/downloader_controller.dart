import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_downloader/controller/ad_mob_controller.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/video_info.dart';
import 'finished_videos_controller.dart';
import 'nav_bar_controller.dart';

class DownloaderController extends GetxController {
  RxBool isLoading = false.obs;
  final controller = TextEditingController();
  RxString url = "".obs;
  RxBool isInitialized = false.obs;
  late Video video;
  final yt = YoutubeExplode();
  List<VideoInfo> info = [VideoInfo(size: "Size", quality: 0)];
  final RxList<VideoInfo> inProgress = <VideoInfo>[].obs;

  void convertVideo() async {
    if (url.trim().isNotEmpty) {
      isInitialized.value = false;
      isLoading.value = true;
      try {
        video = await yt.videos.get(url.value);
        info = [VideoInfo(size: "Size", quality: 0)];
        AdMobController.to.showInterstitialAd();
        await getVideoQualityList();
        isInitialized.value = true;
        isLoading.value = false;
      } catch (error) {
        isLoading.value = false;
        Get.showSnackbar(const GetSnackBar(
          title: "Invalid Video Url",
          message: "Invalid Youtube video ID or URL",
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        ));
      }
    }
  }

  int checkIfSavedBefore(String name) {
    int count = 0;
    Directory dir = Directory('/storage/emulated/0/Download/YoutubeDownloader');
    if (!dir.existsSync()) return count;
    for (final fileSystem in dir.listSync()) {
      final fileName = basenameWithoutExtension(fileSystem.path);
      if (fileName.contains(name)) {
        count++;
      }
    }
    return count;
  }

  downloadVideo(VideoInfo videoInfo) async {
    final NavBarController navBarController = Get.find();
    try {
      videoInfo.isDownloading.value = true;
      inProgress.add(videoInfo);
      navBarController.refreshScreen();
      var manifest = await yt.videos.streamsClient.getManifest(video.url);
      final index = info.indexWhere((element) => element.id == videoInfo.id);
      var muxedStreamInfo = manifest.muxed.elementAt(index - 1);
      String fileName = "${video.title} ${videoInfo.qualityText}"
          .replaceAll(r'\', '')
          .replaceAll('/', '')
          .replaceAll('*', '')
          .replaceAll(':', '')
          .replaceAll('?', '')
          .replaceAll('"', '')
          .replaceAll('<', '')
          .replaceAll('>', '')
          .replaceAll('|', '');
      final fileCount = checkIfSavedBefore(fileName);
      if (fileCount > 0) fileName = "$fileName ($fileCount)";
      var vidStream = yt.videos.streamsClient.get(muxedStreamInfo);
      Directory dir =
          Directory('/storage/emulated/0/Download/YoutubeDownloader');

      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      var file = File('${dir.path}/$fileName.mp4');
      if (file.existsSync()) {}

      var fileStream = file.openWrite(mode: FileMode.writeOnlyAppend);
      var len = muxedStreamInfo.size.totalBytes;
      var count = 0;
      await for (final data in vidStream) {
        count += data.length;
        videoInfo.progress.value = ((count / len) * 100).ceil();
        navBarController.refreshScreen();
        fileStream.add(data);
      }
      inProgress.removeWhere((element) => element.id == videoInfo.id);
      navBarController.refreshScreen();
      videoInfo.isDownloading.value = false;
      videoInfo.isCompleted.value = true;
      FinishedVideosController.to.getFinishedVideos();
      await fileStream.flush();
      await fileStream.close();
    } catch (e) {
      videoInfo.isDownloading.value = false;
      videoInfo.isCompleted.value = false;
      e.printError();
    }
  }

  Future<void> getVideoQualityList() async {
    final manifest = await yt.videos.streamsClient.getManifest(url.value);
    for (final value in manifest.muxed) {
      info.add(VideoInfo(
        id: value.tag,
        video: video,
        size: value.size.toString(),
        quality:
            int.parse(value.qualityLabel.replaceAll(RegExp(r'[^0-9]'), '')),
      ));
    }
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  static String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  String get durationText {
    final time = formatTime(video.duration!);
    return "Duration: $time";
  }

  clear() async {
    controller.clear();
    url.value = "";
    info = [VideoInfo(size: "Size", quality: 0)];
    isInitialized.value = false;
  }
}
