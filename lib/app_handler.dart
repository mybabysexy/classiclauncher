import 'dart:async';

import 'package:classiclauncher/models/app_info.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppHandler extends GetxController {
  static const MethodChannel methodChannel = MethodChannel('com.noaisu.classicLauncher/app');
  RxList<AppInfo> installedApps = RxList();
  Rx<Uint8List?> wallpaper = Rx(null);

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    getAppList();
    // slop change this later
    _timer = Timer.periodic(Duration(seconds: 60), (_) {
      getAppList();
    });
  }

  Future<void> getAppList() async {
    List<AppInfo> apps = [];
    try {
      List<dynamic>? results = await methodChannel.invokeMethod<List<dynamic>>('getApps');

      if (results == null) {
        return;
      }

      for (dynamic appInfo in results) {
        if (appInfo is! Map) {
          continue;
        }

        String? packageName = appInfo["packageName"];
        String? title = appInfo["title"];
        Uint8List? icon = appInfo["icon"];

        if (packageName == null || title == null || icon == null) {
          continue;
        }

        apps.add(AppInfo(packageName: packageName, title: title, icon: icon));

        if (packageName.contains("blackberry")) {
          print("bb found $packageName");
        }
      }

      if (apps.isNotEmpty) {
        installedApps.value = apps;
      }
    } on PlatformException catch (e, stackTrace) {
      print("Failed to get apps $e, $stackTrace");
    }
  }

  Future<void> launchApp(AppInfo app) async {
    try {
      bool? result = await methodChannel.invokeMethod<bool>('launchApp', {"packageName": app.packageName});
    } on PlatformException catch (e, stackTrace) {
      print("Failed to launch app $e, $stackTrace");
    }
  }

  Future<void> launchMail() async {
    AppInfo? bbHub = installedApps.firstWhereOrNull((app) => app.packageName == "com.blackberry.hub");

    if (bbHub != null) {
      return launchApp(bbHub);
    }

    try {
      bool? result = await methodChannel.invokeMethod<bool>('launchMail');
    } on PlatformException catch (e, stackTrace) {
      print("Failed to launch SMS $e, $stackTrace");
    }
  }

  Future<void> launchCamera() async {
    try {
      bool? result = await methodChannel.invokeMethod<bool>('launchCamera');
    } on PlatformException catch (e, stackTrace) {
      print("Failed to launch Camera $e, $stackTrace");
    }
  }
}
