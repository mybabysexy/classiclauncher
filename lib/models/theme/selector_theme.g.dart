// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selector_theme.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SelectorThemeCWProxy {
  SelectorTheme selectorBackgroundColour(Color selectorBackgroundColour);

  SelectorTheme selectorBorderColour(Color selectorBorderColour);

  SelectorTheme selectorBorderRadius(double selectorBorderRadius);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SelectorTheme(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SelectorTheme(...).copyWith(id: 12, name: "My name")
  /// ```
  SelectorTheme call({
    Color selectorBackgroundColour,
    Color selectorBorderColour,
    double selectorBorderRadius,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfSelectorTheme.copyWith(...)` or call `instanceOfSelectorTheme.copyWith.fieldName(value)` for a single field.
class _$SelectorThemeCWProxyImpl implements _$SelectorThemeCWProxy {
  const _$SelectorThemeCWProxyImpl(this._value);

  final SelectorTheme _value;

  @override
  SelectorTheme selectorBackgroundColour(Color selectorBackgroundColour) =>
      call(selectorBackgroundColour: selectorBackgroundColour);

  @override
  SelectorTheme selectorBorderColour(Color selectorBorderColour) =>
      call(selectorBorderColour: selectorBorderColour);

  @override
  SelectorTheme selectorBorderRadius(double selectorBorderRadius) =>
      call(selectorBorderRadius: selectorBorderRadius);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SelectorTheme(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SelectorTheme(...).copyWith(id: 12, name: "My name")
  /// ```
  SelectorTheme call({
    Object? selectorBackgroundColour = const $CopyWithPlaceholder(),
    Object? selectorBorderColour = const $CopyWithPlaceholder(),
    Object? selectorBorderRadius = const $CopyWithPlaceholder(),
  }) {
    return SelectorTheme(
      selectorBackgroundColour:
          selectorBackgroundColour == const $CopyWithPlaceholder() ||
              selectorBackgroundColour == null
          ? _value.selectorBackgroundColour
          // ignore: cast_nullable_to_non_nullable
          : selectorBackgroundColour as Color,
      selectorBorderColour:
          selectorBorderColour == const $CopyWithPlaceholder() ||
              selectorBorderColour == null
          ? _value.selectorBorderColour
          // ignore: cast_nullable_to_non_nullable
          : selectorBorderColour as Color,
      selectorBorderRadius:
          selectorBorderRadius == const $CopyWithPlaceholder() ||
              selectorBorderRadius == null
          ? _value.selectorBorderRadius
          // ignore: cast_nullable_to_non_nullable
          : selectorBorderRadius as double,
    );
  }
}

extension $SelectorThemeCopyWith on SelectorTheme {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfSelectorTheme.copyWith(...)` or `instanceOfSelectorTheme.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SelectorThemeCWProxy get copyWith => _$SelectorThemeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectorTheme _$SelectorThemeFromJson(Map<String, dynamic> json) =>
    SelectorTheme(
      selectorBackgroundColour: json['selectorBackgroundColour'] == null
          ? const Color(0xBE42A7CF)
          : const ColourConverter().fromJson(
              json['selectorBackgroundColour'] as String,
            ),
      selectorBorderColour: json['selectorBorderColour'] == null
          ? const Color(0x9470B9D6)
          : const ColourConverter().fromJson(
              json['selectorBorderColour'] as String,
            ),
      selectorBorderRadius:
          (json['selectorBorderRadius'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$SelectorThemeToJson(SelectorTheme instance) =>
    <String, dynamic>{
      'selectorBackgroundColour': const ColourConverter().toJson(
        instance.selectorBackgroundColour,
      ),
      'selectorBorderColour': const ColourConverter().toJson(
        instance.selectorBorderColour,
      ),
      'selectorBorderRadius': instance.selectorBorderRadius,
    };

const _$SelectorThemeJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'selectorBackgroundColour': {r'$ref': r'#/$defs/Color'},
    'selectorBorderColour': {r'$ref': r'#/$defs/Color'},
    'selectorBorderRadius': {'type': 'number', 'default': 0.0},
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
