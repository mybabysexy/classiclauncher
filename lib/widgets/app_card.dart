import 'dart:async';
import 'dart:ui';

import 'package:classiclauncher/handlers/app_grid_handler.dart';
import 'package:classiclauncher/handlers/app_handler.dart';
import 'package:classiclauncher/models/app_info.dart';
import 'package:classiclauncher/handlers/theme_handler.dart';
import 'package:classiclauncher/screens/selectable_container.dart';
import 'package:classiclauncher/utils/launcher_utils.dart';
import 'package:classiclauncher/widgets/shadowed_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppCard extends StatefulWidget {
  final AppInfo appInfo;
  final double width;
  final double height;
  final String selectableKey;
  final int globalIndex;
  const AppCard({super.key, required this.appInfo, required this.width, required this.height, required this.selectableKey, required this.globalIndex});

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  ThemeHandler themeHandler = Get.find<ThemeHandler>();
  AppHandler appHandler = Get.find<AppHandler>();
  AppGridHandler appGridHandler = Get.find<AppGridHandler>();
  late AnimationController controller;
  late StreamSubscription<bool> sub;
  late Animation<double> scaleAnimation;
  bool isFingerDown = false;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    onEditChange(appGridHandler.editing.value);
    sub = appGridHandler.editing.listen(onEditChange);
    super.initState();
  }

  @override
  void dispose() {
    sub.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AppCard old) {
    super.didUpdateWidget(old);
  }

  void onEditChange(bool editing) {
    if (editing) {
      controller.repeat(reverse: true);
      return;
    }

    controller.stop();
    controller.reset();
  }

  void startEdit(bool dragging) {
    if (appGridHandler.editing.value && dragging) {
      // Already in wobble — just start the drag on this card.
      appGridHandler.dragging.value = true;
      appGridHandler.moving.value = widget.appInfo;
      return;
    }
    if (appGridHandler.editing.value) {
      return;
    }
    appGridHandler.editing.value = true;
    appGridHandler.dragging.value = dragging;
    LauncherUtils.doFeedback();
    appGridHandler.moving.value = widget.appInfo;
  }

  void onDropApp() async {
    final int? moveCol = appGridHandler.appMoveCol;
    final int? moveRow = appGridHandler.appMoveRow;

    appGridHandler.stopDrag();

    if (moveCol == null || moveRow == null) {
      return;
    }

    int appsPerPage = themeHandler.theme.value.appGridTheme.appsPerPage;
    int pageStart = appsPerPage * appGridHandler.pageNotifier.value;
    int offset = (moveRow * themeHandler.theme.value.appGridTheme.columns) + moveCol;
    int appPosition = pageStart + offset;

    await appHandler.moveApp(appPosition: appPosition, app: widget.appInfo);
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      hitTestBehavior: HitTestBehavior.translucent,
      hapticFeedbackOnStart: false,
      onDragStarted: () {
        startEdit(true);
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
                padding: themeHandler.theme.value.appGridTheme.appCardIconPadding,
                child: ShadowedImage(
                  width: themeHandler.theme.value.appGridTheme.iconSize,
                  height: themeHandler.theme.value.appGridTheme.iconSize,
                  imageBytes: widget.appInfo.icon,
                ),
              ),
              Text(widget.appInfo.title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: themeHandler.theme.value.appGridTheme.appCardTextStyle),
            ],
          ),
        ),
      ),
      child: RepaintBoundary(
        child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final bool editing = appGridHandler.editing.value;
          final bool isSystem = widget.appInfo.packageName == "classiclauncher.internal.settings";

          return Transform.scale(
            scale: scaleAnimation.value,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  key: ValueKey("AppCard::${widget.appInfo.packageName}::${widget.width}::${widget.height}"),
                  width: widget.width,
                  height: widget.height,
                  decoration: themeHandler.theme.value.appGridTheme.appCardDecoration,
                  child: Obx(() {
                    final bool? forced = appGridHandler.editing.value
                        ? appGridHandler.highlightedApp.value == widget.appInfo
                        : null;
                    return SelectableContainer(
                      selectableKey: "${widget.selectableKey}_${widget.globalIndex}",
                      selectorTheme: themeHandler.theme.value.appGridTheme.selectorTheme,
                      canLongPress: () => !appGridHandler.editing.value,
                      onTapDown: (details) => setState(() => isFingerDown = true),
                      onTapUp: (details) => setState(() => isFingerDown = false),
                      onTap: () {
                        if (appGridHandler.editing.value) {
                          appHandler.uninstallApp(widget.appInfo);
                          return;
                        }
                        appHandler.launchApp(widget.appInfo);
                      },
                      onLongPress: isFingerDown ? null : () => startEdit(false),
                      forcedSelected: forced,
                      child: Obx(() {
                        if (appGridHandler.moving.value == widget.appInfo && appGridHandler.editing.value && appGridHandler.dragging.value) {
                          return SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: themeHandler.theme.value.appGridTheme.appCardIconPadding,
                              child: ShadowedImage(
                                width: themeHandler.theme.value.appGridTheme.iconSize,
                                height: themeHandler.theme.value.appGridTheme.iconSize,
                                imageBytes: widget.appInfo.icon,
                              ),
                            ),
                            Text(widget.appInfo.title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: themeHandler.theme.value.appGridTheme.appCardTextStyle),
                          ],
                        );
                      }),
                    );
                  }),
                ),
                // Uninstall button — outside the clipped Container so it renders over the corner
                if (editing && !isSystem)
                  Positioned(
                    top: -4,
                    left: -4,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 13),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}
