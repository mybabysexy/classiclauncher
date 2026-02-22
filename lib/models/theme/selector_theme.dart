import 'dart:ui';

import 'package:classiclauncher/models/theme/serializable_util.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'selector_theme.g.dart';

@CopyWith()
@JsonSerializable(createJsonSchema: true)
class SelectorTheme extends Equatable {
  @ColourConverter()
  final Color selectorBackgroundColour;
  @ColourConverter()
  final Color selectorBorderColour;
  final double selectorBorderRadius;

  const SelectorTheme({
    this.selectorBackgroundColour = const Color(0xBE42A7CF),
    this.selectorBorderColour = const Color(0x9470B9D6),
    this.selectorBorderRadius = 0,
  });

  @override
  List<Object?> get props => [selectorBackgroundColour, selectorBorderColour, selectorBorderRadius];

  /// Connect the generated [_$SelectorThemeFromJson] function to the `fromJson`
  /// factory.
  factory SelectorTheme.fromJson(Map<String, dynamic> json) => _$SelectorThemeFromJson(json);

  /// Connect the generated [_$SelectorThemeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SelectorThemeToJson(this);

  BoxDecoration get decoration => BoxDecoration(
    color: selectorBackgroundColour,
    borderRadius: BorderRadius.circular(selectorBorderRadius),
    border: Border(
      top: BorderSide(width: 1, color: selectorBorderColour),
      bottom: BorderSide(width: 1, color: selectorBorderColour),
      left: BorderSide(width: 1, color: selectorBorderColour),
      right: BorderSide(width: 1, color: selectorBorderColour),
    ),
  );

  /// The JSON Schema for this class.
  static const jsonSchema = _$SelectorThemeJsonSchema;
}
