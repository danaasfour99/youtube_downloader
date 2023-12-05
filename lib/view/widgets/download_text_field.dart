import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_downloader/models/custom_colors.dart';

import '../../controller/downloader_controller.dart';

class DownloadTextField extends StatelessWidget {
  final DownloaderController downloaderController;
  const DownloadTextField(this.downloaderController, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: downloaderController.controller,
      onChanged: (value) {
        downloaderController.url.value = value;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: CustomColors.blue, width: 2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.12))),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        hintText: "Paste your url here",
        fillColor: Colors.grey.withOpacity(0.12),
        suffixIcon: downloaderController.url.value.isNotEmpty
            ? IconButton(
                onPressed: downloaderController.clear,
                icon: const Icon(Icons.close))
            : null,
        prefixIconColor: CustomColors.red,
        prefixIcon: const Padding(
            padding: EdgeInsets.only(top: 3, right: 10, left: 10),
            child: Icon(FontAwesomeIcons.link, size: 23)),
      ),
    );
  }
}
