// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_indicator_theme.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PageIndicatorThemeCWProxy {
  PageIndicatorTheme pageIndicatorInactiveSize(
    double pageIndicatorInactiveSize,
  );

  PageIndicatorTheme pageIndicatorActiveSize(double pageIndicatorActiveSize);

  PageIndicatorTheme pageIndicatorSpacing(double pageIndicatorSpacing);

  PageIndicatorTheme pageIndicatorFontSize(double pageIndicatorFontSize);

  PageIndicatorTheme pageIndicatorTextColour(Color pageIndicatorTextColour);

  PageIndicatorTheme indicatorShape(IndicatorShape indicatorShape);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PageIndicatorTheme(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PageIndicatorTheme(...).copyWith(id: 12, name: "My name")
  /// ```
  PageIndicatorTheme call({
    double pageIndicatorInactiveSize,
    double pageIndicatorActiveSize,
    double pageIndicatorSpacing,
    double pageIndicatorFontSize,
    Color pageIndicatorTextColour,
    IndicatorShape indicatorShape,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfPageIndicatorTheme.copyWith(...)` or call `instanceOfPageIndicatorTheme.copyWith.fieldName(value)` for a single field.
class _$PageIndicatorThemeCWProxyImpl implements _$PageIndicatorThemeCWProxy {
  const _$PageIndicatorThemeCWProxyImpl(this._value);

  final PageIndicatorTheme _value;

  @override
  PageIndicatorTheme pageIndicatorInactiveSize(
    double pageIndicatorInactiveSize,
  ) => call(pageIndicatorInactiveSize: pageIndicatorInactiveSize);

  @override
  PageIndicatorTheme pageIndicatorActiveSize(double pageIndicatorActiveSize) =>
      call(pageIndicatorActiveSize: pageIndicatorActiveSize);

  @override
  PageIndicatorTheme pageIndicatorSpacing(double pageIndicatorSpacing) =>
      call(pageIndicatorSpacing: pageIndicatorSpacing);

  @override
  PageIndicatorTheme pageIndicatorFontSize(double pageIndicatorFontSize) =>
      call(pageIndicatorFontSize: pageIndicatorFontSize);

  @override
  PageIndicatorTheme pageIndicatorTextColour(Color pageIndicatorTextColour) =>
      call(pageIndicatorTextColour: pageIndicatorTextColour);

  @override
  PageIndicatorTheme indicatorShape(IndicatorShape indicatorShape) =>
      call(indicatorShape: indicatorShape);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PageIndicatorTheme(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PageIndicatorTheme(...).copyWith(id: 12, name: "My name")
  /// ```
  PageIndicatorTheme call({
    Object? pageIndicatorInactiveSize = const $CopyWithPlaceholder(),
    Object? pageIndicatorActiveSize = const $CopyWithPlaceholder(),
    Object? pageIndicatorSpacing = const $CopyWithPlaceholder(),
    Object? pageIndicatorFontSize = const $CopyWithPlaceholder(),
    Object? pageIndicatorTextColour = const $CopyWithPlaceholder(),
    Object? indicatorShape = const $CopyWithPlaceholder(),
  }) {
    return PageIndicatorTheme(
      pageIndicatorInactiveSize:
          pageIndicatorInactiveSize == const $CopyWithPlaceholder() ||
              pageIndicatorInactiveSize == null
          ? _value.pageIndicatorInactiveSize
          // ignore: cast_nullable_to_non_nullable
          : pageIndicatorInactiveSize as double,
      pageIndicatorActiveSize:
          pageIndicatorActiveSize == const $CopyWithPlaceholder() ||
              pageIndicatorActiveSize == null
          ? _value.pageIndicatorActiveSize
          // ignore: cast_nullable_to_non_nullable
          : pageIndicatorActiveSize as double,
      pageIndicatorSpacing:
          pageIndicatorSpacing == const $CopyWithPlaceholder() ||
              pageIndicatorSpacing == null
          ? _value.pageIndicatorSpacing
          // ignore: cast_nullable_to_non_nullable
          : pageIndicatorSpacing as double,
      pageIndicatorFontSize:
          pageIndicatorFontSize == const $CopyWithPlaceholder() ||
              pageIndicatorFontSize == null
          ? _value.pageIndicatorFontSize
          // ignore: cast_nullable_to_non_nullable
          : pageIndicatorFontSize as double,
      pageIndicatorTextColour:
          pageIndicatorTextColour == const $CopyWithPlaceholder() ||
              pageIndicatorTextColour == null
          ? _value.pageIndicatorTextColour
          // ignore: cast_nullable_to_non_nullable
          : pageIndicatorTextColour as Color,
      indicatorShape:
          indicatorShape == const $CopyWithPlaceholder() ||
              indicatorShape == null
          ? _value.indicatorShape
          // ignore: cast_nullable_to_non_nullable
          : indicatorShape as IndicatorShape,
    );
  }
}

extension $PageIndicatorThemeCopyWith on PageIndicatorTheme {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfPageIndicatorTheme.copyWith(...)` or `instanceOfPageIndicatorTheme.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PageIndicatorThemeCWProxy get copyWith =>
      _$PageIndicatorThemeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageIndicatorTheme _$PageIndicatorThemeFromJson(Map<String, dynamic> json) =>
    PageIndicatorTheme(
      pageIndicatorInactiveSize:
          (json['pageIndicatorInactiveSize'] as num?)?.toDouble() ?? 12,
      pageIndicatorActiveSize:
          (json['pageIndicatorActiveSize'] as num?)?.toDouble() ?? 22,
      pageIndicatorSpacing:
          (json['pageIndicatorSpacing'] as num?)?.toDouble() ?? 28,
      pageIndicatorFontSize:
          (json['pageIndicatorFontSize'] as num?)?.toDouble() ?? 14,
      pageIndicatorTextColour: json['pageIndicatorTextColour'] == null
          ? Colors.black
          : const ColourConverter().fromJson(
              json['pageIndicatorTextColour'] as String,
            ),
      indicatorShape:
          $enumDecodeNullable(
            _$IndicatorShapeEnumMap,
            json['indicatorShape'],
          ) ??
          IndicatorShape.circle,
    );

Map<String, dynamic> _$PageIndicatorThemeToJson(PageIndicatorTheme instance) =>
    <String, dynamic>{
      'pageIndicatorInactiveSize': instance.pageIndicatorInactiveSize,
      'pageIndicatorActiveSize': instance.pageIndicatorActiveSize,
      'pageIndicatorSpacing': instance.pageIndicatorSpacing,
      'pageIndicatorFontSize': instance.pageIndicatorFontSize,
      'pageIndicatorTextColour': const ColourConverter().toJson(
        instance.pageIndicatorTextColour,
      ),
      'indicatorShape': _$IndicatorShapeEnumMap[instance.indicatorShape]!,
    };

const _$PageIndicatorThemeJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'pageIndicatorInactiveSize': {'type': 'number', 'default': 12.0},
    'pageIndicatorActiveSize': {'type': 'number', 'default': 22.0},
    'pageIndicatorSpacing': {'type': 'number', 'default': 28.0},
    'pageIndicatorFontSize': {'type': 'number', 'default': 14.0},
    'pageIndicatorTextColour': {r'$ref': r'#/$defs/Color'},
    'indicatorShape': {'type': 'object'},
  },
  r'$defs': {
    'Color': {
      'type': 'object',
      'properties': {
        'value': {'type': 'integer'},
      },
      'required': ['value'],
    },
  },
};

const _$IndicatorShapeEnumMap = {
  IndicatorShape.circle: 'circle',
  IndicatorShape.squircle: 'squircle',
};
