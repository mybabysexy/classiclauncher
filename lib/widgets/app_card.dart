import 'dart:async';
import 'dart:ui';

import 'package:classiclauncher/app_handler.dart';
import 'package:classiclauncher/models/app_info.dart';
import 'package:classiclauncher/selector_handler.dart';
import 'package:classiclauncher/theme_handler.dart';
import 'package:classiclauncher/widgets/shadowed_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppCard extends StatefulWidget {
  final AppInfo appInfo;
  final double width;
  final double height;

  const AppCard({super.key, required this.appInfo, required this.width, required this.height});

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  ThemeHandler themeHandler = Get.find<ThemeHandler>();
  SelectorHandler selectorHandler = Get.find<SelectorHandler>();
  late AnimationController controller;
  late StreamSubscription<bool> sub;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    onEditChange(selectorHandler.editing.value);
    sub = selectorHandler.editing.listen(onEditChange);
    super.initState();
  }

  @override
  void dispose() {
    sub.cancel();
    controller.dispose();
    super.dispose();
  }

  void onEditChange(bool editing) {
    if (editing) {
      controller.repeat(reverse: true);
      return;
    }

    controller.stop();
    controller.reset();
  }

  void onDropApp() {
    selectorHandler.moving.value = null;
    selectorHandler.editing.value = false;

    if (selectorHandler.appMoveCol == null && selectorHandler.appMoveRow == null) {
      return;
    }

    int appsPerPage = selectorHandler.columns * selectorHandler.rows;

    int pageStart = 0 + (appsPerPage * selectorHandler.appGridPage.value);

    int offset = (selectorHandler.appMoveRow! * selectorHandler.columns) + selectorHandler.appMoveCol!;

    int appPosition = pageStart + offset;

    AppHandler appHandler = Get.find<AppHandler>();
    appHandler.moveApp(appPosition: appPosition, app: widget.appInfo);
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      onDragStarted: () {
        selectorHandler.editing.value = true;
        selectorHandler.doFeedback();
        selectorHandler.moving.value = widget.appInfo;
      },
      onDraggableCanceled: (velocity, offset) {
        print("cancelled");
        onDropApp();
      },
      onDragEnd: (details) {
        print("dragend");
        onDropApp();
      },
      onDragCompleted: () {
        print("dragcomplete");
        onDropApp();
      },
      onDragUpdate: (details) {
        print("dragupdate $details");
      },
      feedback: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: themeHandler.theme.value.appCardIconPadding,
                child: ShadowedImage(width: themeHandler.theme.value.iconSize, height: themeHandler.theme.value.iconSize, imageBytes: widget.appInfo.icon),
              ),
              Text(widget.appInfo.title, textAlign: TextAlign.center, style: themeHandler.theme.value.appCardTextStyle),
            ],
          ),
        ),
      ),
      child: SizedBox(
        key: ValueKey("AppCard::${widget.appInfo.packageName}::${widget.width}::${widget.height}"),
        width: widget.width,
        height: widget.height,
        child: Obx(() {
          if (selectorHandler.moving.value == widget.appInfo && selectorHandler.editing.value) {
            return SizedBox.shrink();
          }
          return AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              return Transform.scale(
                scale: scaleAnimation.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: themeHandler.theme.value.appCardIconPadding,
                      child: ShadowedImage(
                        width: themeHandler.theme.value.iconSize,
                        height: themeHandler.theme.value.iconSize,
                        imageBytes: widget.appInfo.icon,
                      ),
                    ),
                    Text(widget.appInfo.title, textAlign: TextAlign.center, style: themeHandler.theme.value.appCardTextStyle),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
