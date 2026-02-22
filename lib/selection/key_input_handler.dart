import 'package:classiclauncher/models/key_press.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Thin GetX controller that owns the platform event channel and exposes a
/// broadcast stream of [KeyPress] events. Nothing else lives here.
///
/// Register once at app root:
///   Get.put(KeyInputHandler());
class KeyInputHandler extends GetxController {
  static const EventChannel _eventChannel = EventChannel('com.noaisu.classicLauncher/input');

  late final Stream<KeyPress> keyStream;

  @override
  void onInit() {
    super.onInit();
    keyStream = _eventChannel.receiveBroadcastStream().map((e) => KeyPress.fromMap(e as Map<dynamic, dynamic>)).asBroadcastStream();
  }
}
