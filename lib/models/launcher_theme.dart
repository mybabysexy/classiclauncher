import 'dart:ui';

import 'package:flutter/material.dart';

class LauncherTheme {
  final int columns;
  final int rows;
  final double iconSize;
  final TextStyle appCardTextStyle;
  final EdgeInsets appGridOutterPadding;
  final EdgeInsets appCardIconPadding;
  final double columnSpacing;
  final double rowSpacing;
  final double navBarHeight;
  final double navBarIconSize;
  final double navBarSpacing;
  final double pageIndicatorInactiveSize;
  final double pageIndicatorActiveSize;
  final double pageIndicatorSpacing;
  final TextStyle pageIndicatorTextStyle;
  final BoxDecoration selectorDecoration;
  final Color uiPrimaryColour;
  LauncherTheme({
    this.columns = 5,
    this.rows = 3,
    this.iconSize = 68,
    this.appCardTextStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: "SlatePro",
      height: 1,
      color: Color(0xFFe6e6e6),
      shadows: [
        Shadow(offset: Offset(-0.5, -0.5), color: Colors.black),
        Shadow(offset: Offset(0.5, -0.5), color: Colors.black),
        Shadow(offset: Offset(0.5, 0.5), color: Colors.black),
        Shadow(offset: Offset(-0.5, 0.5), color: Colors.black),
        Shadow(blurRadius: 3, color: Colors.black, offset: Offset(0, 1.5)),
      ],
      overflow: TextOverflow.clip,
    ),
    this.rowSpacing = 10,
    this.columnSpacing = 10,
    this.appGridOutterPadding = const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 12),
    this.uiPrimaryColour = const Color(0xFFe6e6e6),
    this.navBarHeight = 82,
    this.navBarSpacing = 16,
    this.navBarIconSize = 48,
    this.appCardIconPadding = const EdgeInsets.only(bottom: 20, left: 8, right: 8, top: 8),
    this.pageIndicatorInactiveSize = 12,
    this.pageIndicatorActiveSize = 22,
    this.pageIndicatorSpacing = 28,
    this.selectorDecoration = const BoxDecoration(
      color: Color(0xBE42A7CF),
      border: Border(
        top: BorderSide(width: 1, color: Color(0x9470B9D6)),
        bottom: BorderSide(width: 1, color: Color(0x9470B9D6)),
        left: BorderSide(width: 1, color: Color(0x9470B9D6)),
        right: BorderSide(width: 1, color: Color(0x9470B9D6)),
      ),
    ),
    this.pageIndicatorTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: "SlatePro", height: 1, color: Colors.black),
  });

  double get gridOutterSideSize => appGridOutterPadding.left + appGridOutterPadding.right;
  double get gridOutterTopsSize => appGridOutterPadding.top + appGridOutterPadding.bottom;
}
