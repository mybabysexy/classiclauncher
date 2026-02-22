import 'package:classiclauncher/models/theme/serializable_util.dart';
import 'package:classiclauncher/widgets/page_indicator.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page_indicator_theme.g.dart';

@CopyWith()
@JsonSerializable(createJsonSchema: true)
class PageIndicatorTheme extends Equatable {
  final double pageIndicatorInactiveSize;
  final double pageIndicatorActiveSize;
  final double pageIndicatorSpacing;
  final double pageIndicatorFontSize;
  @ColourConverter()
  final Color pageIndicatorTextColour;
  final IndicatorShape indicatorShape;

  const PageIndicatorTheme({
    this.pageIndicatorInactiveSize = 12,
    this.pageIndicatorActiveSize = 22,
    this.pageIndicatorSpacing = 28,
    this.pageIndicatorFontSize = 14,
    this.pageIndicatorTextColour = Colors.black,
    this.indicatorShape = IndicatorShape.circle,
  });

  TextStyle get pageIndicatorTextStyle =>
      TextStyle(fontSize: pageIndicatorFontSize, fontWeight: FontWeight.w400, fontFamily: "SlatePro", height: 1, color: pageIndicatorTextColour);

  @override
  List<Object?> get props => [
    pageIndicatorInactiveSize,
    pageIndicatorActiveSize,
    pageIndicatorSpacing,
    pageIndicatorFontSize,
    pageIndicatorTextColour,
    indicatorShape,
  ];

  /// Connect the generated [_$PageIndicatorThemeFromJson] function to the `fromJson`
  /// factory.
  factory PageIndicatorTheme.fromJson(Map<String, dynamic> json) => _$PageIndicatorThemeFromJson(json);

  /// Connect the generated [_$PageIndicatorThemeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PageIndicatorThemeToJson(this);

  /// The JSON Schema for this class.
  static const jsonSchema = _$PageIndicatorThemeJsonSchema;
}
