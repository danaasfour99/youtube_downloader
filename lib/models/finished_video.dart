import 'dart:io';

class FinishedVideo {
  final File thumbnail;
  final File file;
  final String createdDate;
  final String size;

  FinishedVideo(
      {required this.file,
      required this.thumbnail,
      required this.createdDate,
      required this.size});
}
