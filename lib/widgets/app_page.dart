import 'dart:async';
import 'dart:math' as math;

import 'package:classiclauncher/handlers/app_grid_handler.dart';
import 'package:classiclauncher/handlers/app_handler.dart';
import 'package:classiclauncher/models/app_info.dart';
import 'package:classiclauncher/models/enums.dart';
import 'package:classiclauncher/handlers/theme_handler.dart';
import 'package:classiclauncher/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPage extends StatefulWidget {
  final double width;
  final double height;
  final int page;
  final String selectableKey;
  const AppPage({super.key, required this.width, required this.height, required this.page, required this.selectableKey});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final AppHandler appHandler = Get.find<AppHandler>();
  final ThemeHandler themeHandler = Get.find<ThemeHandler>();
  final AppGridHandler appGridHandler = Get.find<AppGridHandler>();
  late Duration duration;
  late StreamSubscription<bool> listener;
  @override
  void initState() {
    duration = appGridHandler.dragging.value ? Duration(milliseconds: 250) : Duration(milliseconds: 50);

    super.initState();

    listener = appGridHandler.dragging.listen((newKey) {
      Duration newDuration = appGridHandler.dragging.value ? Duration(milliseconds: 250) : Duration(milliseconds: 50);

      if (mounted && newDuration != duration) {
        print("setting lnog udration for drag");
        setState(() {
          duration = newDuration;
        });
      }
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  Widget getPositioned({
    required int index,
    required int globalIndex,
    required int columns,
    required double boxWidth,
    required double boxHeight,
    required double columnSpace,
    required double rowSpace,
    required AppInfo app,
  }) {
    final row = index ~/ columns;
    final col = index % columns;

    final top = row * (boxHeight + rowSpace);
    final left = col * (boxWidth + columnSpace);

    return AnimatedPositioned(
      key: ValueKey("AnimatedPositioned::$runtimeType::${app.packageName}"),
      duration: duration,
      top: top,
      left: left,
      child: AppCard(appInfo: app, width: boxWidth, height: boxHeight, selectableKey: widget.selectableKey, globalIndex: globalIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int columns = themeHandler.theme.value.appGridTheme.columns;

      double columnSpace = themeHandler.theme.value.appGridTheme.columnSpacing;
      double rowSpace = themeHandler.theme.value.appGridTheme.rowSpacing;
      EdgeInsets appGridPadding = themeHandler.theme.value.appGridTheme.appGridOutterPadding;
      double boxWidth = themeHandler.getCardWidth(gridWidth: widget.width);
      double boxHeight = themeHandler.getCardHeight(gridHeight: widget.height);

      int appsPerPage = themeHandler.theme.value.appGridTheme.appsPerPage;

      int start = widget.page * appsPerPage;
      int end = math.min(start + appsPerPage, appHandler.installedApps.length);

      List<AppInfo> apps = appHandler.installedApps.sublist(start, end);

      return Padding(
        padding: appGridPadding,
        child: Stack(
          children: [
            for (int index = 0; index < apps.length; index++)
              getPositioned(
                index: index,
                globalIndex: start + index,
                columns: columns,
                boxWidth: boxWidth,
                boxHeight: boxHeight,
                columnSpace: columnSpace,
                rowSpace: rowSpace,
                app: apps[index],
              ),
          ],
        ),
      );
    });
  }
}
