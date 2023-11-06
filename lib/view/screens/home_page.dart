import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/controller/downloader_controller.dart';
import 'package:youtube_downloader/controller/nav_bar_controller.dart';

import '../../models/custom_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavBarController navBarController = Get.find();
    final DownloaderController downloaderController =
        Get.put(DownloaderController());
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(navBarController.title),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: navBarController.floatingButtonColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed: navBarController.returnHome,
          child: const Icon(Icons.home_filled, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: navBarController.icons.length,
          tabBuilder: (int index, bool isActive) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        navBarController.icons[index],
                        size: 24,
                        color: isActive ? CustomColors.blue : Colors.grey,
                      ),
                      Text(
                        navBarController.texts[index],
                        style: TextStyle(
                            color: isActive ? CustomColors.blue : Colors.grey,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (index == 0 && downloaderController.inProgress.isNotEmpty)
                  Positioned.fill(
                    top: -33,
                    left: -24,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 17,
                        width: 17,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColors.red,
                        ),
                        child: Text(
                          downloaderController.inProgress.length.toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
          activeIndex: navBarController.index.value,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: navBarController.changeIndex,
        ),
        body: navBarController.getBody(downloaderController),
      ),
    );
  }
}
