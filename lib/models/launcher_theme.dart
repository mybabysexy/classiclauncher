import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'launcher_theme.g.dart';

class EdgeInsetsConverter implements JsonConverter<EdgeInsets, Map<String, dynamic>> {
  const EdgeInsetsConverter();

  @override
  EdgeInsets fromJson(Map<String, dynamic> json) {
    return EdgeInsets.fromLTRB(
      (json['left'] ?? 0).toDouble(),
      (json['top'] ?? 0).toDouble(),
      (json['right'] ?? 0).toDouble(),
      (json['bottom'] ?? 0).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(EdgeInsets object) {
    return {'left': object.left, 'top': object.top, 'right': object.right, 'bottom': object.bottom};
  }
}

class ColourConverter implements JsonConverter<Color, String> {
  const ColourConverter();

  @override
  Color fromJson(String json) {
    int red = int.parse(json.substring(6, 7), radix: 16);
    int green = int.parse(json.substring(8, 9), radix: 16);
    int blue = int.parse(json.substring(10, 11), radix: 16);
    int alpha = int.parse(json.substring(12, 13), radix: 16);

    return Color.fromARGB(alpha, red, green, blue);
  }

  String toHex(int val) {
    return val.toRadixString(16).padLeft(2, '0');
  }

  @override
  String toJson(Color object) {
    int red = (object.r * 255).round();
    int green = (object.g * 255).round();
    int blue = (object.b * 255).round();
    int alpha = (object.a * 255).round();

    return "RGBA#${toHex(red)}${toHex(green)}${toHex(blue)}${toHex(alpha)}";
  }
}

@JsonSerializable(createJsonSchema: true)
class LauncherTheme {
  final int columns;
  final int rows;
  final double iconSize;
  final double appCardFontSize;
  @ColourConverter()
  final Color appCardTextOutlineColour;
  @EdgeInsetsConverter()
  final EdgeInsets appGridOutterPadding;
  @EdgeInsetsConverter()
  final EdgeInsets appCardIconPadding;
  final double columnSpacing;
  final double rowSpacing;
  final double navBarHeight;
  final double navBarIconSize;
  final double navBarSpacing;
  final double pageIndicatorInactiveSize;
  final double pageIndicatorActiveSize;
  final double pageIndicatorSpacing;
  final double pageIndicatorFontSize;
  @ColourConverter()
  final Color pageIndicatorTextColour;
  @ColourConverter()
  final Color uiPrimaryColour;
  @ColourConverter()
  final Color selectorBackgroundColour;
  @ColourConverter()
  final Color selectorBorderColour;
  final double selectorBorderRadius;

  final Duration appGridEdgeHoverDuration;
  final Duration longPressActionDuration;
  final double appGridEdgeHoverZoneWidth;
  final double menuItemTitleFontSize;
  final double menuItemBodyFontSize;

  @ColourConverter()
  final Color menuItemTitleTextColour;
  @ColourConverter()
  final Color menuItemBodyTextColour;

  LauncherTheme({
    this.columns = 5,
    this.rows = 3,
    this.iconSize = 68,
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
    this.pageIndicatorFontSize = 14,
    this.appGridEdgeHoverDuration = const Duration(milliseconds: 2500),
    this.appGridEdgeHoverZoneWidth = 70,
    this.longPressActionDuration = const Duration(milliseconds: 800),
    this.appCardFontSize = 18,
    this.appCardTextOutlineColour = Colors.black,
    this.selectorBackgroundColour = const Color(0xBE42A7CF),
    this.selectorBorderColour = const Color(0x9470B9D6),
    this.selectorBorderRadius = 0,
    this.pageIndicatorTextColour = Colors.black,
    this.menuItemTitleFontSize = 28,
    this.menuItemBodyFontSize = 22,
    this.menuItemTitleTextColour = Colors.black,
    this.menuItemBodyTextColour = Colors.black87,
  });

  double get gridOutterSideSize => appGridOutterPadding.left + appGridOutterPadding.right;
  double get gridOutterTopsSize => appGridOutterPadding.top + appGridOutterPadding.bottom;
  int get appsPerPage => rows * columns;

  TextStyle get appCardTextStyle => TextStyle(
    fontSize: appCardFontSize,
    fontWeight: FontWeight.w500,
    fontFamily: "SlatePro",
    height: 1,
    color: Color(0xFFe6e6e6),
    shadows: [
      Shadow(offset: Offset(-0.5, -0.5), color: appCardTextOutlineColour),
      Shadow(offset: Offset(0.5, -0.5), color: appCardTextOutlineColour),
      Shadow(offset: Offset(0.5, 0.5), color: appCardTextOutlineColour),
      Shadow(offset: Offset(-0.5, 0.5), color: appCardTextOutlineColour),
      Shadow(blurRadius: 3, color: Colors.black, offset: Offset(0, 1.5)),
    ],
    overflow: TextOverflow.clip,
  );

  TextStyle get pageIndicatorTextStyle =>
      TextStyle(fontSize: pageIndicatorFontSize, fontWeight: FontWeight.w400, fontFamily: "SlatePro", height: 1, color: pageIndicatorTextColour);

  TextStyle get menuItemTitleTextStyle =>
      TextStyle(fontSize: menuItemTitleFontSize, fontWeight: FontWeight.w400, fontFamily: "SlatePro", height: 1, color: menuItemTitleTextColour);

  TextStyle get menuItemBodyTextStyle =>
      TextStyle(fontSize: menuItemBodyFontSize, fontWeight: FontWeight.w300, fontFamily: "SlatePro", height: 1, color: menuItemBodyTextColour);

  BoxDecoration get selectorDecoration => BoxDecoration(
    color: selectorBackgroundColour,
    borderRadius: BorderRadius.circular(selectorBorderRadius),
    border: Border(
      top: BorderSide(width: 1, color: selectorBorderColour),
      bottom: BorderSide(width: 1, color: selectorBorderColour),
      left: BorderSide(width: 1, color: selectorBorderColour),
      right: BorderSide(width: 1, color: selectorBorderColour),
    ),
  );

  /// Connect the generated [_$LauncherThemeFromJson] function to the `fromJson`
  /// factory.
  factory LauncherTheme.fromJson(Map<String, dynamic> json) => _$LauncherThemeFromJson(json);

  /// Connect the generated [_$LauncherThemeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LauncherThemeToJson(this);

  /// The JSON Schema for this class.
  static const jsonSchema = _$LauncherThemeJsonSchema;
}
