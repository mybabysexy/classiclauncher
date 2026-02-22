import 'dart:ui';

import 'package:classiclauncher/models/theme/selector_theme.dart';
import 'package:classiclauncher/models/theme/serializable_util.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_theme.g.dart';

@CopyWith()
@JsonSerializable(createJsonSchema: true)
class SettingsTheme extends Equatable {
  final double menuItemTitleFontSize;
  final double menuItemBodyFontSize;
  @ColourConverter()
  final Color menuItemBorderColour;
  @ColourConverter()
  final Color menuItemTitleTextColour;
  @ColourConverter()
  final Color menuItemBodyTextColour;
  @ColourConverter()
  final Color menuItemTitleSelectedTextColour;
  @ColourConverter()
  final Color menuItemBodySelectedTextColour;
  @ColourConverter()
  final Color backgroundColour;
  final SelectorTheme selectorTheme;

  const SettingsTheme({
    this.menuItemTitleFontSize = 28,
    this.menuItemBodyFontSize = 22,
    this.menuItemTitleTextColour = Colors.black,
    this.menuItemBodyTextColour = Colors.black87,
    this.menuItemBorderColour = Colors.grey,
    this.backgroundColour = Colors.white,
    this.menuItemBodySelectedTextColour = Colors.white70,
    this.menuItemTitleSelectedTextColour = Colors.white,
    this.selectorTheme = const SelectorTheme(),
  });

  TextStyle get menuItemTitleTextStyle =>
      TextStyle(fontSize: menuItemTitleFontSize, fontWeight: FontWeight.w400, fontFamily: "SlatePro", height: 1, color: menuItemTitleTextColour);

  TextStyle get menuItemBodyTextStyle =>
      TextStyle(fontSize: menuItemBodyFontSize, fontWeight: FontWeight.w300, fontFamily: "SlatePro", height: 1, color: menuItemBodyTextColour);

  TextStyle get menuItemTitleSelectedTextStyle =>
      TextStyle(fontSize: menuItemTitleFontSize, fontWeight: FontWeight.w400, fontFamily: "SlatePro", height: 1, color: menuItemTitleSelectedTextColour);

  TextStyle get menuItemBodySelectedTextStyle =>
      TextStyle(fontSize: menuItemBodyFontSize, fontWeight: FontWeight.w300, fontFamily: "SlatePro", height: 1, color: menuItemBodySelectedTextColour);

  @override
  List<Object?> get props => [
    menuItemTitleFontSize,
    menuItemBodyFontSize,
    menuItemBorderColour,
    menuItemTitleTextColour,
    menuItemBodyTextColour,
    menuItemBodySelectedTextColour,
    menuItemTitleSelectedTextColour,
    selectorTheme,
  ];

  /// Connect the generated [_$SettingsThemeFromJson] function to the `fromJson`
  /// factory.
  factory SettingsTheme.fromJson(Map<String, dynamic> json) => _$SettingsThemeFromJson(json);

  /// Connect the generated [_$SettingsThemeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SettingsThemeToJson(this);

  /// The JSON Schema for this class.
  static const jsonSchema = _$SettingsThemeJsonSchema;
}
