import 'dart:async';

import 'package:classiclauncher/models/app_info.dart';
import 'package:classiclauncher/models/key_press.dart';
import 'package:classiclauncher/selection/key_input_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppGridHandler extends GetxController with WidgetsBindingObserver {
  final RxBool editing = RxBool(false);
  final Rx<AppInfo?> moving = Rx(null);
  final RxBool dragging = RxBool(false);
  final RxInt selectedGridIndex = 0.obs;
  /// The app that should show the DPAD highlight. Set after a move resolves,
  /// so it's always in sync with the actual list order.
  final Rx<AppInfo?> highlightedApp = Rx(null);
  int? appMoveCol;
  int? appMoveRow;
  Rx<Timer?> pageChangeEdgeTimer = Rx(null);
  late StreamSubscription inputSub;
  Rx<double?> fingerX = Rx(null);
  Rx<double?> fingerY = Rx(null);

  ValueNotifier<int> pageNotifier = ValueNotifier(0);
  /// Updated immediately when a swipe target is decided, before the animation finishes.
  ValueNotifier<int> targetPageNotifier = ValueNotifier(0);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    inputSub = Get.find<KeyInputHandler>().keyStream.listen((keyPress) {
      if (keyPress.input == Input.back && editing.value) {
        stopEdit();
      }
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      if (editing.value) {
        stopEdit();
      }
    }
  }

  /// Ends the active drag but keeps wobble (editing) mode alive.
  void stopDrag() {
    dragging.value = false;
    moving.value = null;
    highlightedApp.value = null;
    fingerX.value = null;
    fingerY.value = null;
    appMoveCol = null;
    appMoveRow = null;
  }

  void stopEdit() {
    moving.value = null;
    dragging.value = false;
    editing.value = false;
    highlightedApp.value = null;
    fingerX.value = null;
    fingerY.value = null;
    appMoveCol = null;
    appMoveRow = null;
  }

  void clearTimer() {
    pageChangeEdgeTimer.value?.cancel();
    pageChangeEdgeTimer.value = null;
  }
}
