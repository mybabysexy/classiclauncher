import 'dart:ui';

import 'package:classiclauncher/models/theme/app_grid_theme.dart';
import 'package:classiclauncher/models/theme/page_indicator_theme.dart';
import 'package:classiclauncher/models/theme/selector_theme.dart';
import 'package:classiclauncher/models/theme/serializable_util.dart';
import 'package:classiclauncher/models/theme/settings_theme.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'launcher_theme.g.dart';

@CopyWith()
@JsonSerializable(createJsonSchema: true)
class LauncherTheme extends Equatable {
  final double navBarHeight;
  final double navBarIconSize;
  final double navBarSpacing;
  @ColourConverter()
  final Color uiPrimaryColour;

  final Duration longPressActionDuration;
  final AppGridTheme appGridTheme;
  final PageIndicatorTheme pageIndicatorTheme;
  final SettingsTheme settingsTheme;

  const LauncherTheme({
    this.uiPrimaryColour = const Color(0xFFe6e6e6),
    this.navBarHeight = 82,
    this.navBarSpacing = 16,
    this.navBarIconSize = 48,
    this.longPressActionDuration = const Duration(milliseconds: 800),

    this.appGridTheme = const AppGridTheme(),
    this.pageIndicatorTheme = const PageIndicatorTheme(),
    this.settingsTheme = const SettingsTheme(),
  });

  /// Connect the generated [_$LauncherThemeFromJson] function to the `fromJson`
  /// factory.
  factory LauncherTheme.fromJson(Map<String, dynamic> json) => _$LauncherThemeFromJson(json);

  /// Connect the generated [_$LauncherThemeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LauncherThemeToJson(this);

  /// The JSON Schema for this class.
  static const jsonSchema = _$LauncherThemeJsonSchema;

  @override
  List<Object?> get props => [
    navBarHeight,
    navBarIconSize,
    navBarSpacing,
    uiPrimaryColour,
    longPressActionDuration,
    appGridTheme,
    pageIndicatorTheme,
    settingsTheme,
  ];
}
