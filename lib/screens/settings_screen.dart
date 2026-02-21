import 'dart:convert';
import 'dart:typed_data';

import 'package:classiclauncher/handlers/app_handler.dart';
import 'package:classiclauncher/handlers/theme_handler.dart';
import 'package:classiclauncher/models/launcher_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeHandler themeHandler = Get.find<ThemeHandler>();
  AppHandler appHandler = Get.find<AppHandler>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            SizedBox(height: Get.mediaQuery.padding.top + 16),
            GestureDetector(
              onTap: () async {
                final String? path = await appHandler.getSAFDirectoryAccess();

                if (path == null) {
                  return;
                }

                await appHandler.writeFile(utf8.encode(jsonEncode(themeHandler.theme.value)), "theme_${DateTime.now()}", 'text/json', 'json', path);
              },
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(left: 16, right: 16, top: 10, bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text("Export Theme", style: themeHandler.theme.value.menuItemTitleTextStyle, textAlign: TextAlign.start),

                            SizedBox(height: 4),
                            Text("Export the current theme as Json", style: themeHandler.theme.value.menuItemBodyTextStyle, textAlign: TextAlign.start),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final String path = await appHandler.getSAFUri();

                Uint8List? bytes = await appHandler.getSAFFile(path);

                if (bytes == null) {
                  print("null bytes returning");
                  return;
                }

                try {
                  LauncherTheme theme = LauncherTheme.fromJson(jsonDecode(utf8.decode(bytes)));

                  themeHandler.theme.value = theme;
                } catch (e, stackTrace) {
                  print("Failed to load theme $e, $stackTrace");
                }
              },
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(left: 16, right: 16, top: 10, bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text("Import Theme", style: themeHandler.theme.value.menuItemTitleTextStyle, textAlign: TextAlign.start),

                            SizedBox(height: 4),
                            Text("Import a theme Json file", style: themeHandler.theme.value.menuItemBodyTextStyle, textAlign: TextAlign.start),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
