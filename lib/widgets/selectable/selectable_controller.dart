import 'dart:async';

import 'package:classiclauncher/handlers/theme_handler.dart';
import 'package:classiclauncher/models/enums.dart';
import 'package:classiclauncher/selection/key_input_handler.dart';
import 'package:classiclauncher/utils/launcher_utils.dart';
import 'package:classiclauncher/widgets/selectable/selectable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/key_press.dart';

class SelectableController {
  final List<SelectableZone> zones = [];
  int zoneIndex = 0;
  late StreamSubscription inputSub;
  ValueNotifier<String?> selectedItemNotifier = ValueNotifier(null);
  ValueNotifier<KeyPress?> inputNotifier = ValueNotifier(null);
  ValueNotifier<KeyPress?> longPressNotifier = ValueNotifier(null);
  SelectableZone? get currentZone => zones.isNotEmpty ? zones[zoneIndex] : null;
  ThemeHandler themeHandler = Get.find<ThemeHandler>();

  Duration frameTime = Duration(milliseconds: 45);
  DateTime? lastMove;
  List<KeyPress> inputsSinceLastFrame = [];
  bool animatingPage = false;
  RxMap<int, Timer> heldInputs = RxMap();
  List<int> cancelRelease = [];
  String route;

  SelectableController({required this.route}) {
    inputSub = Get.find<KeyInputHandler>().keyStream.listen((keyPress) {
      if (Get.currentRoute != route) {
        return;
      }

      if (route == "/SettingsScreen" && keyPress.input == Input.back && keyPress.state == KeyState.keyUp) {
        Get.back();
        return;
      }

      Direction? direction = keyPress.direction;

      if (selectedItemNotifier.value == null) {
        setSelected(0);
      }

      if (direction != null) {
        handleDirection(keyPress, direction);
        return;
      }
      if (keyPress.state == KeyState.keyUp && heldInputs[keyPress.keyCode] != null) {
        heldInputs[keyPress.keyCode]?.cancel();
        heldInputs.remove(keyPress.keyCode);
        print("long press cancelled $keyPress");
      }

      if (keyPress.state == KeyState.keyDown && !heldInputs.containsKey(keyPress.keyCode)) {
        print("long press queued $keyPress");
        queueLongPress(keyPress);
      }

      if (keyPress.state == KeyState.keyUp && cancelRelease.contains(keyPress.keyCode)) {
        cancelRelease.remove(keyPress.keyCode);
        print("Cancelling release for $keyPress");
        return;
      }

      inputNotifier.value = keyPress;

      print("input announced $keyPress");
      return;
    });
  }

  void queueLongPress(KeyPress keyPress) {
    heldInputs.putIfAbsent(
      keyPress.keyCode,
      () => Timer(themeHandler.theme.value.longPressActionDuration, () {
        print("long press detected $keyPress");
        cancelRelease.add(keyPress.keyCode);
        heldInputs[keyPress.keyCode]!.cancel();
        heldInputs.remove(keyPress.keyCode);
        longPressNotifier.value = keyPress;
        inputNotifier.value = null;
      }),
    );
  }

  void handleDirection(KeyPress keyPress, Direction direction) {
    DateTime now = DateTime.now();

    if (lastMove != null && now.difference(lastMove!) < frameTime) {
      inputsSinceLastFrame.add(keyPress);
      return;
    }

    print("Doing move $direction, ${inputsSinceLastFrame.isNotEmpty ? MoveType.hard : MoveType.soft}");

    handleMove(direction, inputsSinceLastFrame.isNotEmpty ? MoveType.hard : MoveType.soft);

    lastMove = now;
    inputsSinceLastFrame = [];
  }

  Input? getInput(KeyPress keyPress) {
    switch (keyPress.keyCode) {
      case 66:
        return Input.select;
    }
    return null;
  }

  void registerZone(SelectableZone zone, int zoneChildIndex, int? zoneIndex) {
    if (zoneIndex == null) {
      zones.add(zone);
    } else {
      zones.insert(zoneIndex, zone);
    }
  }

  void setSelected(int index) {
    String newKey = '${currentZone?.zoneKey}_$index';

    if (newKey == selectedItemNotifier.value) {
      return;
    }
    selectedItemNotifier.value = '${currentZone?.zoneKey}_$index';
    print(selectedItemNotifier.value);
    LauncherUtils.doFeedback();
  }

  void unregisterZone(SelectableZone zone) {
    zones.remove(zone);
  }

  void handleMove(Direction direction, MoveType moveType) {
    SelectableZone? current = currentZone;

    if (currentZone == null) {
      return;
    }

    int index = current!.handleMove(direction, moveType);

    if (index != -1) {
      setSelected(index);
      return;
    }

    _moveBetweenzones(direction, moveType);
  }

  void _moveBetweenzones(Direction direction, MoveType moveType) {
    if (moveType == MoveType.soft) {
      return;
    }

    if (direction == Direction.down && zoneIndex < zones.length - 1) {
      zoneIndex++;
    }

    if (direction == Direction.up && zoneIndex > 0) {
      zoneIndex--;
    }

    setSelected(currentZone!.currentIndex);
  }

  void setSelectedFromKeyString(String key) {
    int itemIndex = int.parse(key.split("_")[1]);

    String zoneString = key.split("_")[0];

    int zoneIndex = zones.indexWhere((zone) => zone.runtimeType.toString() == zoneString);

    if (zoneIndex == -1) {
      return;
    }

    this.zoneIndex = zoneIndex;

    setSelected(itemIndex);
  }
}
