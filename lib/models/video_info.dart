import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoInfo {
  final int quality;
  final String size;
  final int id;
  final Video? video;
  RxInt progress = 0.obs;
  RxBool isCompleted = false.obs;
  RxBool isDownloading = false.obs;

  VideoInfo({
    this.video,
    required this.size,
    required this.quality,
    this.id = -1,
  });

  String get qualityText => quality == 0 ? "Quality" : '${quality}p';
}
