import 'dart:ui';

import 'package:classiclauncher/app_handler.dart';
import 'package:classiclauncher/models/app_info.dart';
import 'package:classiclauncher/selector_handler.dart';
import 'package:classiclauncher/theme_handler.dart';
import 'package:classiclauncher/utils/constants.dart';
import 'package:classiclauncher/widgets/app_card.dart';
import 'package:classiclauncher/widgets/app_page.dart';
import 'package:classiclauncher/widgets/custom_page_view.dart';
import 'package:classiclauncher/widgets/page_indicator.dart';
import 'package:classiclauncher/widgets/selector_container.dart';
import 'package:classiclauncher/widgets/shadowed_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/enums.dart';

void main() {
  Get.put(AppHandler(), permanent: true);
  Get.put(ThemeHandler(), permanent: true);
  Get.put(SelectorHandler(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      color: Colors.transparent,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AppHandler appHandler = Get.find<AppHandler>();
  final ThemeHandler themeHandler = Get.find<ThemeHandler>();
  final SelectorHandler selectorHandler = Get.find<SelectorHandler>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Obx(() {
        int columns = themeHandler.theme.value.columns;
        int rows = themeHandler.theme.value.rows;
        int appsPerPage = rows * columns;
        List<AppInfo> apps = appHandler.installedApps;

        int pageCount = (apps.length / appsPerPage).round();

        return SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [
              SizedBox(height: 32),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return PageGestureWrapper(
                      constraints: constraints,
                      children: [for (int i = 0; i < pageCount; i++) AppPage(width: constraints.maxWidth, height: constraints.maxHeight, page: i)],
                    );
                    /*   return PageView(
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      controller: selectorHandler.pageController,
                      children: [for (int i = 0; i < pageCount; i++) AppPage(width: constraints.maxWidth, height: constraints.maxHeight, page: i)],
                    ); */
                  },
                ),
              ),
              SizedBox(
                height: themeHandler.theme.value.navBarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return Padding(
                        padding: EdgeInsetsGeometry.only(left: themeHandler.theme.value.navBarSpacing, right: themeHandler.theme.value.navBarSpacing),
                        child: SelectorContainer(
                          selectorKey: "${NavGroup.navBar.name}_0",
                          child: SizedBox(
                            height: themeHandler.theme.value.navBarHeight,
                            width: themeHandler.theme.value.navBarHeight,
                            child: ShadowedImage(
                              width: themeHandler.theme.value.navBarIconSize,
                              height: themeHandler.theme.value.navBarIconSize,
                              assetPath: appHandler.loliSnatcher.value == null ? iconMessages : iconKanna2,
                            ),
                          ),
                        ),
                      );
                    }),
                    Expanded(
                      child: SelectorContainer(
                        selectorKey: "${NavGroup.navBar.name}_1",
                        child: SizedBox(
                          height: themeHandler.theme.value.navBarHeight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Obx(() => PageIndicators(selected: selectorHandler.appGridPage.value, pageCount: pageCount))],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.only(left: themeHandler.theme.value.navBarSpacing, right: themeHandler.theme.value.navBarSpacing),
                      child: SelectorContainer(
                        selectorKey: "${NavGroup.navBar.name}_2",
                        child: SizedBox(
                          height: themeHandler.theme.value.navBarHeight,
                          width: themeHandler.theme.value.navBarHeight,
                          child: ShadowedImage(
                            width: themeHandler.theme.value.navBarIconSize,
                            height: themeHandler.theme.value.navBarIconSize,
                            assetPath: iconCamera,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
