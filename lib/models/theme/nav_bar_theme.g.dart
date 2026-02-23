// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nav_bar_theme.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NavBarThemeCWProxy {
  NavBarTheme iconColour(Color iconColour);

  NavBarTheme navBarHeight(double navBarHeight);

  NavBarTheme navBarSpacing(double navBarSpacing);

  NavBarTheme navBarIconSize(double navBarIconSize);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `NavBarTheme(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// NavBarTheme(...).copyWith(id: 12, name: "My name")
  /// ```
  NavBarTheme call({
    Color iconColour,
    double navBarHeight,
    double navBarSpacing,
    double navBarIconSize,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfNavBarTheme.copyWith(...)` or call `instanceOfNavBarTheme.copyWith.fieldName(value)` for a single field.
class _$NavBarThemeCWProxyImpl implements _$NavBarThemeCWProxy {
  const _$NavBarThemeCWProxyImpl(this._value);

  final NavBarTheme _value;

  @override
  NavBarTheme iconColour(Color iconColour) => call(iconColour: iconColour);

  @override
  NavBarTheme navBarHeight(double navBarHeight) =>
      call(navBarHeight: navBarHeight);

  @override
  NavBarTheme navBarSpacing(double navBarSpacing) =>
      call(navBarSpacing: navBarSpacing);

  @override
  NavBarTheme navBarIconSize(double navBarIconSize) =>
      call(navBarIconSize: navBarIconSize);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `NavBarTheme(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// NavBarTheme(...).copyWith(id: 12, name: "My name")
  /// ```
  NavBarTheme call({
    Object? iconColour = const $CopyWithPlaceholder(),
    Object? navBarHeight = const $CopyWithPlaceholder(),
    Object? navBarSpacing = const $CopyWithPlaceholder(),
    Object? navBarIconSize = const $CopyWithPlaceholder(),
  }) {
    return NavBarTheme(
      iconColour:
          iconColour == const $CopyWithPlaceholder() || iconColour == null
          ? _value.iconColour
          // ignore: cast_nullable_to_non_nullable
          : iconColour as Color,
      navBarHeight:
          navBarHeight == const $CopyWithPlaceholder() || navBarHeight == null
          ? _value.navBarHeight
          // ignore: cast_nullable_to_non_nullable
          : navBarHeight as double,
      navBarSpacing:
          navBarSpacing == const $CopyWithPlaceholder() || navBarSpacing == null
          ? _value.navBarSpacing
          // ignore: cast_nullable_to_non_nullable
          : navBarSpacing as double,
      navBarIconSize:
          navBarIconSize == const $CopyWithPlaceholder() ||
              navBarIconSize == null
          ? _value.navBarIconSize
          // ignore: cast_nullable_to_non_nullable
          : navBarIconSize as double,
    );
  }
}

extension $NavBarThemeCopyWith on NavBarTheme {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfNavBarTheme.copyWith(...)` or `instanceOfNavBarTheme.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NavBarThemeCWProxy get copyWith => _$NavBarThemeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavBarTheme _$NavBarThemeFromJson(Map<String, dynamic> json) => NavBarTheme(
  iconColour: json['iconColour'] == null
      ? const Color(0xFFe6e6e6)
      : const ColourConverter().fromJson(json['iconColour'] as String),
  navBarHeight: (json['navBarHeight'] as num?)?.toDouble() ?? 82,
  navBarSpacing: (json['navBarSpacing'] as num?)?.toDouble() ?? 16,
  navBarIconSize: (json['navBarIconSize'] as num?)?.toDouble() ?? 48,
);

Map<String, dynamic> _$NavBarThemeToJson(NavBarTheme instance) =>
    <String, dynamic>{
      'navBarHeight': instance.navBarHeight,
      'navBarIconSize': instance.navBarIconSize,
      'navBarSpacing': instance.navBarSpacing,
      'iconColour': const ColourConverter().toJson(instance.iconColour),
    };

const _$NavBarThemeJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'navBarHeight': {'type': 'number', 'default': 82.0},
    'navBarIconSize': {'type': 'number', 'default': 48.0},
    'navBarSpacing': {'type': 'number', 'default': 16.0},
    'iconColour': {r'$ref': r'#/$defs/Color'},
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
