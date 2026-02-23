import 'package:classiclauncher/handlers/app_grid_handler.dart';
import 'package:classiclauncher/handlers/app_handler.dart';
import 'package:classiclauncher/handlers/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDragOverlay extends StatefulWidget {
  final double width;
  final double height;
  const AppDragOverlay({super.key, required this.width, required this.height});

  @override
  State<AppDragOverlay> createState() => _AppDragOverlayState();
}

class _AppDragOverlayState extends State<AppDragOverlay> {
  final AppHandler appHandler = Get.find<AppHandler>();
  final ThemeHandler themeHandler = Get.find<ThemeHandler>();
  final AppGridHandler appGridHandler = Get.find<AppGridHandler>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!appGridHandler.editing.value || !appGridHandler.dragging.value) {
        return SizedBox.shrink();
      }
      if (appGridHandler.fingerX.value == null || appGridHandler.fingerY.value == null) {
        return SizedBox.shrink();
      }

      final int columns = themeHandler.theme.value.appGridTheme.columns;
      final int rows = themeHandler.theme.value.appGridTheme.rows;
      final double columnSpace = themeHandler.theme.value.appGridTheme.columnSpacing;
      final double rowSpace = themeHandler.theme.value.appGridTheme.rowSpacing;
      final EdgeInsets padding = themeHandler.theme.value.appGridTheme.appGridOutterPadding;
      final double boxWidth = themeHandler.getCardWidth(gridWidth: widget.width);
      final double boxHeight = themeHandler.getCardHeight(gridHeight: widget.height);
      final double columnStride = boxWidth + columnSpace;
      final double rowStride = boxHeight + rowSpace;

      final double x = appGridHandler.fingerX.value! - padding.left;
      final double y = appGridHandler.fingerY.value!;

      // Determine which cell the finger is over.
      final int col = (x / columnStride).floor().clamp(0, columns - 1);
      final int row = (y / rowStride).floor().clamp(0, rows - 1);

      // Set the move target — read by onDropApp before stopEdit clears them.
      appGridHandler.appMoveCol = col;
      appGridHandler.appMoveRow = row;

      // Indicator shown at the left edge of the hovered cell.
      final double indicatorLeft = padding.left + col * columnStride - columnSpace / 2 + 2;
      final double indicatorTop = row * rowStride;

      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            Positioned(
              top: indicatorTop,
              height: boxHeight,
              left: indicatorLeft,
              width: 6,
              child: Container(decoration: themeHandler.theme.value.appGridTheme.selectorTheme.decoration),
            ),
          ],
        ),
      );
    });
  }
}
