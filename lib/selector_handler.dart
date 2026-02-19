import 'package:classiclauncher/app_handler.dart';
import 'package:classiclauncher/models/key_press.dart';
import 'package:classiclauncher/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum NavGroup { appGrid, navBar }

enum Edge { top, left, right, bottom }

enum MoveType { soft, hard }

enum Direction { up, down, left, right }

class SelectorHandler extends GetxController {
  final ThemeHandler themeHandler = Get.find<ThemeHandler>();
  final AppHandler appHandler = Get.find<AppHandler>();

  Rx<NavGroup?> selectedNavGroup = Rx(null);
  RxInt selectedIndex = 0.obs; // index within current zone
  final PageController pageController = PageController();

  static const EventChannel eventChannel = EventChannel('com.noaisu.classicLauncher/input');

  int get columns => themeHandler.theme.value.columns;
  int get rows => themeHandler.theme.value.rows;
  int get appsPerPage => columns * rows;
  int get appCount => appHandler.installedApps.length;
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
    selectedKey.value = '${selectedNavGroup.value?.name}_${selectedIndex.value}';

    print("selectkey = ${selectedKey.value}");
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

  void handleKeyPress(KeyPress keyPress) {
    if (keyPress.state != KeyState.keyUp) {
      return;
    }
    if (keyPress.isTrackPadDirection) {
      handleDirection(keyPress);
    }

    if (keyPress.keyCode == 66) {
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
        appHandler.launchApp(appHandler.installedApps[index]);
        break;
      case NavGroup.navBar:
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
      selectedIndex.value = 0;
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
      doGridMove(direction: direction, moveType: moveType, columnCount: columns, rowCount: rows, maxItems: appCount, navGroup: NavGroup.appGrid);
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
    final int localIndex = selectedIndex.value % (columnCount * rowCount);
    final int currentRow = localIndex ~/ columnCount;
    final int currentCol = localIndex % columnCount;
    final int pageSize = columnCount * rowCount;
    final int currentPage = selectedIndex.value ~/ pageSize;
    final int nextPageStart = (currentPage + 1) * pageSize;
    final int prevPageStart = (currentPage - 1) * pageSize;

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
          selectedIndex.value = lastApp;
          print("at up moving to widget above");
          return;
        }
        selectedIndex.value = (selectedIndex.value - columnCount).clamp(0, maxItems);
        break;
      case Direction.down:
        if (isTopEdge && !hasBottomSibling) {
          return;
        }

        if (isBottomEdge && hasBottomSibling) {
          selectedNavGroup.value = selectedNavGroup.value = NavGroup.values[navGroupIndex + 1];
          lastApp = selectedIndex.value;
          selectedIndex.value = 0;
          print("at bottom moving to widget below");
          return;
        }

        selectedIndex.value = (selectedIndex.value + columnCount).clamp(0, maxItems);

        break;

      case Direction.left:
        // Lock to grid if slow
        if (isLeftEdge && (moveType == MoveType.soft || currentPage == 0)) {
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
    int page = index ~/ appsPerPage;

    await pageController.animateToPage(page, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    animatingPage = false;
  }
}
