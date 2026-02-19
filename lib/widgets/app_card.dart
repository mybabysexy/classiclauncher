import 'dart:ui';

import 'package:classiclauncher/models/app_info.dart';
import 'package:classiclauncher/theme_handler.dart';
import 'package:classiclauncher/widgets/shadowed_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppCard extends StatefulWidget {
  final AppInfo appInfo;
  final double width;
  final double height;

  const AppCard({super.key, required this.appInfo, required this.width, required this.height});

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  ThemeHandler themeHandler = Get.find<ThemeHandler>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: themeHandler.theme.value.appCardIconPadding,
              child: ShadowedImage(width: themeHandler.theme.value.iconSize, height: themeHandler.theme.value.iconSize, imageBytes: widget.appInfo.icon),
            ),
            Text(widget.appInfo.title, textAlign: TextAlign.center, style: themeHandler.theme.value.appCardTextStyle),
          ],
        ),
      ),
    );
  }
}
