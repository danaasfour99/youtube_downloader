import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/controller/ad_mob_controller.dart';
import 'package:youtube_downloader/controller/downloader_controller.dart';
import 'package:youtube_downloader/view/screens/finished_screen.dart';
import 'package:youtube_downloader/view/screens/in_progress_screen.dart';

import '../models/custom_colors.dart';
import '../view/screens/download_screen.dart';
import 'finished_videos_controller.dart';

class NavBarController extends GetxController with WidgetsBindingObserver {
  static NavBarController get to => Get.find();
  RxInt index = 2.obs;
  bool isAppPaused = false;
  final List<IconData> icons = [Icons.download, Icons.folder_rounded];
  final List<String> texts = ["In progress", "Finished"];

  changeIndex(int index) {
    if (this.index.value == index) return;
    AdMobController.to.createBannerAd();
    this.index.value = index;
  }

  returnHome() {
    changeIndex(2);
  }

  Color get floatingButtonColor {
    if (index.value == 2) {
      return CustomColors.blue;
    } else {
      return CustomColors.silver;
    }
  }

  String get title {
    switch (index.value) {
      case 0:
        return "In progress";
      case 1:
        return "Finished";
      default:
        return "Youtube downloader";
    }
  }

  refreshScreen() {
    index.refresh();
  }

  Widget getBody(DownloaderController downloaderController) {
    switch (index.value) {
      case 0:
        return InProgressScreen(downloaderController);
      case 1:
        return const FinishedScreen();
      default:
        return DownloadScreen(downloaderController);
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isAppPaused = true;
    }
    if (isAppPaused && state == AppLifecycleState.resumed) {
      FinishedVideosController.to.getFinishedVideos();
    }
  }
}
