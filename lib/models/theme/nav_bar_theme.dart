import 'dart:ui';

import 'package:classiclauncher/models/theme/selector_theme.dart';
import 'package:classiclauncher/models/theme/serializable_util.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nav_bar_theme.g.dart';

@CopyWith()
@JsonSerializable(createJsonSchema: true)
class NavBarTheme extends Equatable {
  final double navBarHeight;
  final double navBarIconSize;
  final double navBarSpacing;
  @ColourConverter()
  final Color iconColour;

  const NavBarTheme({this.iconColour = const Color(0xFFe6e6e6), this.navBarHeight = 82, this.navBarSpacing = 16, this.navBarIconSize = 48});

  @override
  List<Object?> get props => [navBarHeight, navBarIconSize, navBarSpacing, iconColour];

  /// Connect the generated [_$NavBarThemeFromJson] function to the `fromJson`
  /// factory.
  factory NavBarTheme.fromJson(Map<String, dynamic> json) => _$NavBarThemeFromJson(json);

  /// Connect the generated [_$NavBarThemeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$NavBarThemeToJson(this);

  /// The JSON Schema for this class.
  static const jsonSchema = _$NavBarThemeJsonSchema;
}
