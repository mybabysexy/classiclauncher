import 'dart:async';
import 'dart:ui';

import 'package:classiclauncher/handlers/app_handler.dart';
import 'package:classiclauncher/models/app_info.dart';
import 'package:classiclauncher/handlers/selector_handler.dart';
import 'package:classiclauncher/handlers/theme_handler.dart';
import 'package:classiclauncher/widgets/selector_container.dart';
import 'package:classiclauncher/widgets/shadowed_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../models/enums.dart';

class AppCard extends StatefulWidget {
  final AppInfo appInfo;
  final double width;
  final double height;
  final int globalIndex;
  const AppCard({super.key, required this.appInfo, required this.width, required this.height, required this.globalIndex});

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
    selectorHandler.fingerX.value = null;
    selectorHandler.fingerY.value = null;

    if (selectorHandler.appMoveCol == null && selectorHandler.appMoveRow == null) {
      return;
    }

    int appsPerPage = themeHandler.theme.value.appsPerPage;

    int pageStart = 0 + (appsPerPage * selectorHandler.appGridPage.value);

    int offset = (selectorHandler.appMoveRow! * themeHandler.theme.value.columns) + selectorHandler.appMoveCol!;

    int appPosition = pageStart + offset;

    AppHandler appHandler = Get.find<AppHandler>();
    appHandler.moveApp(appPosition: appPosition, app: widget.appInfo);
    selectorHandler.moving.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      delay: themeHandler.theme.value.longPressActionDuration,
      hapticFeedbackOnStart: false,
      onDragStarted: () {
        selectorHandler.editing.value = true;
        selectorHandler.selectedNavGroup.value = null;
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
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Transform.scale(
            scale: scaleAnimation.value,
            child: SizedBox(
              key: ValueKey("AppCard::${widget.appInfo.packageName}::${widget.width}::${widget.height}"),
              width: widget.width,
              height: widget.height,
              child: SelectorContainer(
                key: ValueKey("${NavGroup.appGrid.name}_${widget.globalIndex}_${widget.appInfo.packageName}"),
                selectorKey: "${NavGroup.appGrid.name}_${widget.globalIndex}",
                child: Obx(() {
                  if (selectorHandler.moving.value == widget.appInfo && selectorHandler.editing.value && selectorHandler.selectedNavGroup.value == null) {
                    return SizedBox.shrink();
                  }

                  return Column(
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
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
