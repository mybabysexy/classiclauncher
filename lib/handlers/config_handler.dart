import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

enum ConfigType { theme, appPositions }

// use a queue to prevnt collision/corruption on file writing
class WriteQueue<T> {
  Future<void> _last = Future.value();

  Future<T> queueAndWait(Future<T> Function() action) {
    Completer<T> completer = Completer<T>();

    _last = _last.then((_) => action()).then(completer.complete, onError: completer.completeError);

    return completer.future;
  }
}

class ConfigHandler extends GetxController {
  final Map<ConfigType, WriteQueue> _writeQueues = {};

  Future<void> saveConfig({required String config, required ConfigType configType}) async {
    WriteQueue queue = _writeQueues.putIfAbsent(configType, () => WriteQueue());

    return queue.queueAndWait(() async {
      await _writeFile(config: config, configType: configType);
    });
  }

  Future<void> deleteConfig({required ConfigType configType}) async {
    WriteQueue queue = _writeQueues.putIfAbsent(configType, () => WriteQueue());

    return queue.queueAndWait(() async {
      await _deleteFile(configType: configType);
    });
  }

  Future<void> _deleteFile({required ConfigType configType}) async {
    final Directory appDocumentsDir = await getApplicationSupportDirectory();

    File file = File('${appDocumentsDir.path}/${configType.name}.json');

    try {
      await file.delete();
    } catch (e, stackTrace) {
      print("Failed to store file $configType, $e, $stackTrace");
    }
  }

  Future<void> _writeFile({required String config, required ConfigType configType}) async {
    final Directory appDocumentsDir = await getApplicationSupportDirectory();

    File file = File('${appDocumentsDir.path}/${configType.name}.json');

    try {
      await file.writeAsString(config);
    } catch (e, stackTrace) {
      print("Failed to store file $configType, $e, $stackTrace");
    }
  }

  Future<String> loadConfig({required ConfigType configType}) async {
    final Directory appDocumentsDir = await getApplicationSupportDirectory();

    File file = File('${appDocumentsDir.path}/${configType.name}.json');

    print("looking for ${file.path}");

    print("${appDocumentsDir.listSync()}");

    try {
      bool exists = await file.exists();
      if (exists) {
        return file.readAsString();
      }
    } catch (e, stackTrace) {
      print("Failed to load file $configType, $e, $stackTrace");
    }

    return "";
  }
}
