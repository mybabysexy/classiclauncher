import 'package:classiclauncher/handlers/app_handler.dart';
import 'package:classiclauncher/models/key_press.dart';
import 'package:classiclauncher/handlers/theme_handler.dart';
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

  DateTime? swipeStart;
  List<KeyPress> frame = [];
  Duration frameTime = Duration(milliseconds: 60);

  void handleKeyPress(KeyPress keyPress) {
    if (keyPress.state != KeyState.keyUp) return;
    if (!keyPress.isTrackPadDirection) return;

    DateTime now = DateTime.now();

    if (swipeStart == null) {
      swipeStart = now;
      frame.add(keyPress);
      return;
    }

    if (now.difference(swipeStart!) >= frameTime || (frame.isNotEmpty && keyPress.keyCode != frame[0].keyCode)) {
      processFrame();
      frame.clear();
      swipeStart = now;
    }

    frame.add(keyPress);
  }

  void processFrame() {
    if (frame.isEmpty) return;
    int keyCount = frame.length;
    if (keyCount == 1) return;

    // find most common keycode in frame
    Map<int, int> counts = {};
    for (KeyPress kp in frame) {
      counts[kp.keyCode] = (counts[kp.keyCode] ?? 0) + 1;
    }
    int dominantKeyCode = counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    KeyPress keyPress = frame.firstWhere((kp) => kp.keyCode == dominantKeyCode);

    late MoveType move;
    if (keyCount >= 3) {
      move = MoveType.hard;
    } else {
      move = MoveType.soft;
    }

    triggerMove(keyPress, move);
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

    int? nextIndex;

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
        // Move to prev page same row if fast
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

  // initialize selection or move between zones
  void doMoveDown(MoveType moveType) {
    if (selectedNavGroup.value == NavGroup.appGrid) {
      final int localIndex = selectedIndex.value % (columns * rows);
      bool isBottomEdge = (localIndex ~/ columns) == rows - 1;

      print("index selected is ${selectedIndex.value},local:$localIndex, bottomEdge:$isBottomEdge");
      if (isBottomEdge) {
        selectedNavGroup.value = NavGroup.navBar;
        lastApp = selectedIndex.value;
        selectedIndex.value = 0;

        return;
      } else {
        selectedIndex.value = (selectedIndex.value + columns).clamp(0, appCount);
      }
    }
  }

  void doMoveUp(MoveType moveType) {
    if (selectedNavGroup.value == NavGroup.navBar) {
      selectedNavGroup.value = NavGroup.appGrid;
      selectedIndex.value = lastApp;
      return;
    }

    if (selectedNavGroup.value == NavGroup.appGrid) {
      final int localIndex = selectedIndex.value % (columns * rows);
      final int row = localIndex ~/ columns;
      bool isTopEdge = row == 0;

      print("index selected is ${selectedIndex.value},local:$localIndex, topEdge:$isTopEdge");
      if (isTopEdge) {
        return;
      } else {
        selectedIndex.value = (selectedIndex.value - columns).clamp(0, appCount);
      }
    }
  }

  void doMoveRight() {
    if (selectedNavGroup.value == NavGroup.appGrid) {
      final int localIndex = selectedIndex.value % (columns * rows);
      final int row = localIndex ~/ columns;
      final int col = localIndex % columns;
      bool isRightEdge = col == columns - 1;

      print("index selected is ${selectedIndex.value},local:$localIndex, rightEdge:$isRightEdge");
    }
    selectedIndex.value++;
  }

  void doMoveLeft() {
    if (selectedNavGroup.value == NavGroup.appGrid) {
      final int localIndex = selectedIndex.value % appsPerPage;
      final int row = localIndex ~/ columns;
      final int col = localIndex % columns;

      bool isLeftEdge = col == 0;

      print("index selected is ${selectedIndex.value}, local:$localIndex, leftEdge:$isLeftEdge");

      if (isLeftEdge) {
        final int currentPage = selectedIndex.value ~/ appsPerPage;

        // no previous page → stop
        if (currentPage == 0) {
          return;
        }

        final int prevPageStart = (currentPage - 1) * appsPerPage;
        final int prevIndex = prevPageStart + (row * columns) + (columns - 1);

        if (prevIndex < appCount) {
          _scrollToIndex(prevIndex);
        }

        return;
      }
    }

    selectedIndex.value--;
  }

  void _scrollToIndex(int index) {
    int page = index ~/ appsPerPage;

    pageController.animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
