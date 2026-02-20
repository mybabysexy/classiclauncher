import 'dart:async';

import 'package:classiclauncher/handlers/app_handler.dart';
import 'package:classiclauncher/models/app_info.dart';
import 'package:classiclauncher/models/enums.dart';
import 'package:classiclauncher/models/key_press.dart';
import 'package:classiclauncher/handlers/theme_handler.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SelectorHandler extends GetxController {
  final ThemeHandler themeHandler = Get.find<ThemeHandler>();
  final AppHandler appHandler = Get.find<AppHandler>();
  final RxBool editing = RxBool(false);
  final Rx<AppInfo?> moving = Rx(null);

  Rx<NavGroup?> selectedNavGroup = Rx(null);
  RxInt selectedIndex = 0.obs;
  RxInt appGridPage = 0.obs;
  Rx<Timer?> pageChangeEdgeTimer = Rx(null);

  Rx<double?> fingerX = Rx(null);
  Rx<double?> fingerY = Rx(null);

  int? appMoveCol;
  int? appMoveRow;

  static const EventChannel eventChannel = EventChannel('com.noaisu.classicLauncher/input');

  int get _columns => themeHandler.theme.value.columns;
  int get _rows => themeHandler.theme.value.rows;
  int get _appsPerPage => themeHandler.theme.value.appsPerPage;
  int get _appCount => appHandler.installedApps.length;
  int lastApp = 0;

  Rx<String?> selectedKey = Rx(null);

  @override
  void onInit() {
    super.onInit();
    final keyStream = eventChannel.receiveBroadcastStream().map((e) => KeyPress.fromMap(e as Map<dynamic, dynamic>));
    keyStream.listen(handleKeyPress);
    ever(selectedIndex, (_) => _updateKey());
    ever(selectedNavGroup, (_) => _updateKey());
  }

  void _updateKey() {
    print("oldkey = ${selectedKey.value}");
    selectedKey.value = '${selectedNavGroup.value?.name}_${selectedIndex.value}';
    if (selectedNavGroup.value != null) {
      doFeedback();
    }
    if (moving.value != null && editing.value) {
      appHandler.moveApp(appPosition: selectedIndex.value, app: moving.value!);
    }

    print("selectkey = ${selectedKey.value}");
  }

  void clearTimer() {
    pageChangeEdgeTimer.value?.cancel();
    pageChangeEdgeTimer.value = null;
  }

  void doFeedback() {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
  }

  Duration frameTime = Duration(milliseconds: 45);
  DateTime? lastMove;
  List<KeyPress> inputsSinceLastFrame = [];
  bool animatingPage = false;

  void handleDirection(KeyPress keyPress) {
    if (animatingPage) {
      return;
    }
    DateTime now = DateTime.now();

    if (lastMove != null && now.difference(lastMove!) < frameTime) {
      inputsSinceLastFrame.add(keyPress);
      return;
    }

    print("moving as ${inputsSinceLastFrame.isNotEmpty ? MoveType.hard : MoveType.soft},inputs = ${inputsSinceLastFrame.length} ");
    triggerMove(keyPress, inputsSinceLastFrame.isNotEmpty ? MoveType.hard : MoveType.soft);

    lastMove = now;
    inputsSinceLastFrame = [];
  }

  RxMap<Input, Timer> heldInputs = RxMap();
  List<Input> cancelRelease = [];

  void handleKeyPress(KeyPress keyPress) {
    if (keyPress.isTrackPadDirection && keyPress.state == KeyState.keyUp) {
      handleDirection(keyPress);
    }

    if (keyPress.state == KeyState.keyDown) {
      print("press started");
      heldInputs.putIfAbsent(
        Input.select,
        () => Timer(themeHandler.theme.value.longPressActionDuration, () {
          if (editing.value) {
            print("long press detected while editing returning");
            return;
          }
          print("long press detected");
          cancelRelease.add(Input.select);
          heldInputs[Input.select]!.cancel();
          heldInputs.remove(Input.select);
          if (selectedNavGroup.value == NavGroup.appGrid) {
            editing.value = true;
            moving.value = appHandler.installedApps[selectedIndex.value];
          }
        }),
      );
    }

    if (keyPress.keyCode == 66 && keyPress.state == KeyState.keyUp && heldInputs.containsKey(Input.select)) {
      heldInputs[Input.select]!.cancel();
      heldInputs.remove(Input.select);

      print("press ended");
    }

    if (keyPress.keyCode == 66 && keyPress.state == KeyState.keyUp && cancelRelease.contains(Input.select)) {
      cancelRelease.remove(Input.select);
      print("release cancelled");
      return;
    }

    if (keyPress.keyCode == 66 && keyPress.state == KeyState.keyUp && editing.value) {
      editing.value = false;
      moving.value = null;
      return;
    }

    if (keyPress.keyCode == 66 && keyPress.state == KeyState.keyUp) {
      handleWidgetPress();
    }
  }

  void handleWidgetPress({String? widgetKey}) {
    NavGroup? navGroup = selectedNavGroup.value;
    int index = selectedIndex.value;

    if (widgetKey != null) {
      navGroup = NavGroup.values.byName(widgetKey.split("_")[0]);
      index = int.parse(widgetKey.split("_")[1]);
    }

    if (navGroup == null) {
      return;
    }

    switch (navGroup) {
      case NavGroup.appGrid:
        doFeedback();
        appHandler.launchApp(appHandler.installedApps[index]);
        break;
      case NavGroup.navBar:
        doFeedback();
        if (index == 0) {
          appHandler.launchMail();
        }
        if (index == 2) {
          appHandler.launchCamera();
        }
        break;
    }
  }

  void triggerMove(KeyPress keyPress, MoveType moveType) {
    if (selectedNavGroup.value == null) {
      selectedNavGroup.value = NavGroup.appGrid;
      selectedIndex.value = _appsPerPage * appGridPage.value;
      return;
    }

    if (selectedNavGroup.value == NavGroup.appGrid && selectedIndex.value < _appsPerPage * appGridPage.value) {
      selectedIndex.value = _appsPerPage * appGridPage.value;
      return;
    }

    if (!keyPress.isTrackPadDirection) {
      return;
    }

    late Direction direction;

    switch (keyPress.keyCode) {
      case 19:
        direction = Direction.up;
        break;
      case 20:
        direction = Direction.down;
        break;
      case 21:
        direction = Direction.left;
        break;
      case 22:
        direction = Direction.right;
        break;
    }

    print("$moveType in direction: $direction");

    if (selectedNavGroup.value == NavGroup.appGrid) {
      doGridMove(direction: direction, moveType: moveType, columnCount: _columns, rowCount: _rows, maxItems: _appCount, navGroup: NavGroup.appGrid);
    } else {
      doGridMove(direction: direction, moveType: moveType, columnCount: 3, rowCount: 1, maxItems: 3, navGroup: NavGroup.navBar);
    }
  }

  void doGridMove({
    required Direction direction,
    required MoveType moveType,
    required int columnCount,
    required int rowCount,
    required int maxItems,
    required NavGroup navGroup,
  }) {
    int localIndex = selectedIndex.value % (columnCount * rowCount);
    int currentRow = localIndex ~/ columnCount;
    int currentCol = localIndex % columnCount;
    int pageSize = columnCount * rowCount;
    int currentPage = selectedIndex.value ~/ pageSize;
    int nextPageStart = (currentPage + 1) * pageSize;
    int prevPageStart = (currentPage - 1) * pageSize;
    int maxPage = ((maxItems / pageSize).round() - 1);

    bool isRightEdge = currentCol == columnCount - 1;
    bool isTopEdge = currentRow == 0;
    bool isBottomEdge = (localIndex ~/ columnCount) == rowCount - 1;
    bool isLeftEdge = currentCol == 0;

    int navGroupIndex = NavGroup.values.indexOf(navGroup);

    bool hasTopSibling = navGroupIndex > 0;
    bool hasBottomSibling = navGroupIndex < (NavGroup.values.length - 1);

    switch (direction) {
      case Direction.up:
        if (isTopEdge && !hasTopSibling) {
          return;
        }

        if (hasTopSibling && isTopEdge) {
          selectedNavGroup.value = NavGroup.values[navGroupIndex - 1];

          selectedIndex.value = (lastApp % _appsPerPage) + (_appsPerPage * appGridPage.value);

          print("at up moving to widget above");
          return;
        }
        selectedIndex.value = (selectedIndex.value - columnCount).clamp(0, maxItems);
        break;
      case Direction.down:
        if (isTopEdge && !hasBottomSibling) {
          return;
        }

        if (isBottomEdge && hasBottomSibling && !editing.value) {
          selectedNavGroup.value = selectedNavGroup.value = NavGroup.values[navGroupIndex + 1];
          lastApp = selectedIndex.value;
          selectedIndex.value = 0;
          print("at bottom moving to widget below");
          return;
        }

        selectedIndex.value = (selectedIndex.value + columnCount).clamp(0, maxItems);

        break;

      case Direction.left:
        if (isLeftEdge && currentPage == 0) {
          return;
        }
        // Lock to grid if slow
        if (isLeftEdge && moveType == MoveType.soft) {
          return;
        }
        // Move to prev page same row if hard
        if (isLeftEdge && moveType == MoveType.hard) {
          selectedIndex.value = prevPageStart + (currentRow * columnCount) + (columnCount - 1);
          _scrollToIndex(selectedIndex.value);
          print("at left moving to prev page");
          return;
        }

        selectedIndex.value--;

        break;
      case Direction.right:
        // Lock to grid if slow
        if (isRightEdge && maxPage == currentPage) {
          return;
        }
        if (isRightEdge && moveType == MoveType.soft) {
          return;
        }

        // Move to next page same row if fast
        if (isRightEdge && moveType == MoveType.hard) {
          selectedIndex.value = nextPageStart + (currentRow * columnCount);
          _scrollToIndex(selectedIndex.value);
          print("at right moving to prev page");
          return;
        }
        selectedIndex.value++;

        break;
    }
  }

  void _scrollToIndex(int index) async {
    animatingPage = true;

    int page = index ~/ _appsPerPage;

    appGridPage.value = page;
    animatingPage = false;
  }
}
