import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:classiclauncher/models/app_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class AppHandler extends GetxController {
  static const MethodChannel methodChannel = MethodChannel('com.noaisu.classicLauncher/app');
  RxList<AppInfo> installedApps = RxList();
  RxList<String> appPositions = RxList();
  Rx<Uint8List?> wallpaper = Rx(null);
  Rx<AppInfo?> loliSnatcher = Rx(null);
  RxBool writingAppList = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    getAppPositions();
    getAppList();
    _timer = Timer.periodic(Duration(seconds: 30), (_) {
      getAppList();
    });
  }

  Future<void> getAppPositions() async {
    try {
      final Directory appDocumentsDir = await getApplicationSupportDirectory();

      File appPositionsFile = File('${appDocumentsDir.path}/appPositions.json');

      String fileString = await appPositionsFile.readAsString();

      List<String> packagePositions = [...jsonDecode(fileString)];

      appPositions.value = packagePositions;
    } catch (e, stackTrace) {
      print("Failled to load app positions $e, $stackTrace");
    }
  }

  Future<void> getAppList() async {
    if (writingAppList.value) {
      return;
    }

    try {
      Map<String, AppInfo> apps = {};
      AppInfo? loliSnatcherInfo;
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

        AppInfo currentApp = AppInfo(packageName: packageName, title: title, icon: icon);

        apps[packageName] = currentApp;

        if (packageName.contains("loliSnatcher")) {
          loliSnatcherInfo = currentApp;
        }
      }

      List<String> positions = appPositions.value;
      List<AppInfo> newAppList = [];

      for (String package in positions) {
        if (!apps.containsKey(package)) {
          continue;
        }

        newAppList.add(apps.remove(package)!);
      }

      newAppList.addAll(apps.values);

      if (!listEquals(newAppList, installedApps)) {
        loliSnatcher.value = loliSnatcherInfo;
        installedApps.value = newAppList;
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
    if (loliSnatcher.value != null) {
      return launchApp(loliSnatcher.value!);
    }

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

  Future<void> moveApp({required int appPosition, required AppInfo app}) async {
    writingAppList.value = true;
    List<AppInfo> newAppList = installedApps.value;

    newAppList.remove(app);
    newAppList.insert(appPosition, app);
    installedApps.refresh();

    installedApps.value = newAppList;

    List<String> packageNames = newAppList.map((AppInfo current) => current.packageName).toList();

    appPositions.value = packageNames;

    try {
      final Directory appDocumentsDir = await getApplicationSupportDirectory();

      File appPositionsFile = File('${appDocumentsDir.path}/appPositions.json');

      await appPositionsFile.writeAsString(jsonEncode(packageNames));
    } catch (e, stackTrace) {
      print("Failled to store app positions $e, $stackTrace");
    }

    writingAppList.value = false;
  }
}
