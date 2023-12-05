import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:youtube_downloader/models/custom_colors.dart';
import 'package:youtube_downloader/view/screens/home_page.dart';

import 'controller/ad_mob_controller.dart';
import 'controller/permission_binding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: ["2CDC8460BA357E9BA2554AC66DF66681"]);
  MobileAds.instance.updateRequestConfiguration(configuration);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdMobController());
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetMaterialApp(
        initialBinding: PermissionBinding(),
        debugShowCheckedModeBanner: false,
        title: 'Video downloader',
        theme: ThemeData(
          fontFamily: "Kanit",
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            minimumSize: Size(width * 0.6, 60),
            backgroundColor: CustomColors.blue,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.withOpacity(0.12),
            textStyle: const TextStyle(fontSize: 24, fontFamily: "Kanit"),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          )),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
                fontFamily: "Kanit",
                color: CustomColors.black,
                fontWeight: FontWeight.w400),
          ),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              titleTextStyle: TextStyle(
                color: CustomColors.black,
                fontSize: 22,
              )),
          colorScheme: ColorScheme.fromSeed(
              seedColor: CustomColors.blue, background: Colors.white),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
