import 'package:get/get.dart';
import 'package:youtube_downloader/controller/finished_videos_controller.dart';
import 'package:youtube_downloader/controller/nav_bar_controller.dart';

class PermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FinishedVideosController());
    Get.put(NavBarController());
  }
}
