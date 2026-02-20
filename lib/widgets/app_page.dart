import 'dart:async';
import 'dart:math' as math;

import 'package:classiclauncher/handlers/app_handler.dart';
import 'package:classiclauncher/handlers/selector_handler.dart';
import 'package:classiclauncher/models/app_info.dart';
import 'package:classiclauncher/models/enums.dart';
import 'package:classiclauncher/handlers/theme_handler.dart';
import 'package:classiclauncher/widgets/app_card.dart';
import 'package:classiclauncher/widgets/selector_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPage extends StatefulWidget {
  final double width;
  final double height;
  final int page;
  const AppPage({super.key, required this.width, required this.height, required this.page});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final AppHandler appHandler = Get.find<AppHandler>();
  final SelectorHandler selectorHandler = Get.find<SelectorHandler>();
  final ThemeHandler themeHandler = Get.find<ThemeHandler>();
  late Duration duration;
  late StreamSubscription<NavGroup?> listener;
  @override
  void initState() {
    duration = selectorHandler.selectedNavGroup.value == null ? Duration(milliseconds: 250) : Duration(milliseconds: 50);

    super.initState();

    listener = selectorHandler.selectedNavGroup.listen((newKey) {
      Duration newDuration = selectorHandler.selectedNavGroup.value == null ? Duration(milliseconds: 250) : Duration(milliseconds: 50);

      if (mounted && newDuration != duration) {
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
      key: ValueKey("AnimatedPositioned::$runtimeType::${NavGroup.appGrid.name}_${app.packageName}"),
      duration: duration,
      top: top,
      left: left,
      child: AppCard(appInfo: app, width: boxWidth, height: boxHeight, globalIndex: globalIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    int columns = themeHandler.theme.value.columns;

    double columnSpace = themeHandler.theme.value.columnSpacing;
    double rowSpace = themeHandler.theme.value.rowSpacing;
    EdgeInsets appGridPadding = themeHandler.theme.value.appGridOutterPadding;
    double boxWidth = themeHandler.getCardWidth(gridWidth: widget.width);
    double boxHeight = themeHandler.getCardHeight(gridHeight: widget.height);

    int appsPerPage = themeHandler.theme.value.appsPerPage;

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
  }
}
