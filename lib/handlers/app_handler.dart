import 'dart:async';
import 'dart:convert';

import 'package:classiclauncher/handlers/config_handler.dart';
import 'package:classiclauncher/models/app_info.dart';
import 'package:classiclauncher/screens/settings_screen.dart';
import 'package:classiclauncher/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppHandler extends GetxController with WidgetsBindingObserver {
  static const MethodChannel methodChannel = MethodChannel('com.noaisu.classicLauncher/app');
  RxList<AppInfo> installedApps = RxList();
  RxList<String> appPositions = RxList();
  Rx<Uint8List?> wallpaper = Rx(null);
  Rx<AppInfo?> loliSnatcher = Rx(null);
  RxBool writingAppList = false.obs;
  RxBool editingApps = false.obs;
  ConfigHandler configHandler = Get.find<ConfigHandler>();

  Timer? _timer;

  static const EventChannel packageEventChannel = EventChannel('com.noaisu.classicLauncher/packages');
  StreamSubscription? _packageEventSub;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    getAppPositions();
    getAppList();
    _timer = Timer.periodic(Duration(seconds: 30), (_) {
      getAppList();
    });
    _packageEventSub = packageEventChannel.receiveBroadcastStream().listen((event) {
      getAppList();
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _packageEventSub?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Keep as fallback in case the broadcast receiver misses an event.
    if (state == AppLifecycleState.resumed) {
      getAppList();
    }
  }

  Future<Uint8List> loadAssetBytes(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Future<void> getAppPositions() async {
    try {
      String positionsString = await configHandler.loadConfig(configType: ConfigType.appPositions);

      if (positionsString.isEmpty) {
        return;
      }

      List<String> packagePositions = [...jsonDecode(positionsString)];

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
      List<dynamic>? results = await methodChannel.invokeMethod<List<dynamic>>('getApps') ?? [];

      Uint8List settingsIconBytes = await loadAssetBytes(iconSettingsApp);

      apps["classiclauncher.internal.settings"] = AppInfo(
        packageName: "classiclauncher.internal.settings",
        title: "Launcher Settings",
        icon: settingsIconBytes,
      );

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
    if (app.packageName == "classiclauncher.internal.settings") {
      Get.to(SettingsScreen());
      return;
    }

    try {
      bool? result = await methodChannel.invokeMethod<bool>('launchApp', {"packageName": app.packageName});
    } on PlatformException catch (e, stackTrace) {
      print("Failed to launch app $e, $stackTrace");
    }
  }

  Future<void> uninstallApp(AppInfo app) async {
    if (app.packageName == "classiclauncher.internal.settings") return;
    try {
      await methodChannel.invokeMethod('uninstallApp', {"packageName": app.packageName});
    } on PlatformException catch (e, stackTrace) {
      print("Failed to uninstall app $e, $stackTrace");
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
    List<AppInfo> newAppList = [...installedApps];

    int currentIndex = installedApps.indexOf(app);

    if (currentIndex == appPosition) {
      print("tried moving ${app.packageName} to same position $currentIndex");
      return;
    }

    newAppList.remove(app);
    newAppList.insert(appPosition, app);
    print("move ${app.packageName} from $currentIndex to $appPosition");

    if (newAppList == installedApps) {
      return;
    }

    installedApps.value = newAppList;

    List<String> packageNames = newAppList.map((AppInfo current) => current.packageName).toList();

    appPositions.value = packageNames;

    await configHandler.saveConfig(config: jsonEncode(packageNames), configType: ConfigType.appPositions);

    writingAppList.value = false;
  }

  Future<String?> writeFile(dynamic fileData, String fileName, String mediaType, String fileExt, String? extPathOverride) async {
    String? result;
    try {
      result = await methodChannel.invokeMethod('writeFile', {
        'fileData': fileData,
        'fileName': fileName,
        'mediaType': mediaType,
        'fileExt': fileExt,
        'extPathOverride': extPathOverride,
      });
    } catch (e, stackTrace) {
      print("Failed to write file $e, $stackTrace");
    }
    return result;
  }

  Future<String?> getSAFDirectoryAccess() async {
    String? result;
    try {
      result = await methodChannel.invokeMethod('getTempDirAccess');
      print('Got saf path back $result');
    } catch (e, stackTrace) {
      print("Failed to get saf path $e, $stackTrace");
    }
    return result;
  }

  Future<Uint8List?> getSAFFile(String contentUri) async {
    Uint8List? result;
    try {
      result = await methodChannel.invokeMethod('getFileBytes', {'uri': contentUri});
      print('Got file back');
    } catch (e, stackTrace) {
      print("Failed to get saf file $e, $stackTrace");
    }
    // File(result+"/test.txt").create(recursive: true);
    return result;
  }

  Future<String> getSAFUri() async {
    String result = '';
    try {
      result = await methodChannel.invokeMethod('getFileUri');
      print('Got saf uri back: $result');
    } catch (e, stackTrace) {
      print("Failed to get saf uri $e, $stackTrace");
    }
    // File(result+"/test.txt").create(recursive: true);
    return result;
  }

  Future<void> openWallpaperPicker() async {
    try {
      await methodChannel.invokeMethod('openWallpaperPicker');
    } catch (e, stackTrace) {
      print("Failed to set wallpaper $e, $stackTrace");
    }
  }

  Future<void> exportAppOrder() async {
    try {
      final String? path = await getSAFDirectoryAccess();

      if (path == null) {
        return;
      }

      String fileName = 'appOrder_${DateTime.now()}';

      await writeFile(utf8.encode(jsonEncode(appPositions)), fileName, 'text/json', 'json', path);

      Get.snackbar("App order exported ( Ո‿Ո)", "saved to $fileName.json ...", backgroundColor: Colors.black54, colorText: Colors.white);
    } catch (e, stackTrace) {
      print("Failed to export app order $e,$stackTrace");
      Get.snackbar("Failed to export app order ૮(˶ㅠ︿ㅠ)ა", "$e", backgroundColor: Colors.black54, colorText: Colors.white);
    }
  }

  Future<void> importAppOrder() async {
    try {
      final String path = await getSAFUri();
      Uint8List? bytes = await getSAFFile(path);
      if (bytes == null) {
        throw Exception("null bytes returning");
      }
      final List<String> newPositions = [...jsonDecode(utf8.decode(bytes))];

      appPositions.value = newPositions;
      Get.snackbar("App order imported ( Ո‿Ո)", "app order has been imported", backgroundColor: Colors.black54, colorText: Colors.white);
      getAppList();
    } catch (e, stackTrace) {
      print("Failed to import app order $e,$stackTrace");
      Get.snackbar("Failed to import app order ૮(˶ㅠ︿ㅠ)ა", "$e", backgroundColor: Colors.black54, colorText: Colors.white);
    }
  }
}
