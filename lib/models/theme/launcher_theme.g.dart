// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launcher_theme.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LauncherThemeCWProxy {
  LauncherTheme uiPrimaryColour(Color uiPrimaryColour);

  LauncherTheme navBarHeight(double navBarHeight);

  LauncherTheme navBarSpacing(double navBarSpacing);

  LauncherTheme navBarIconSize(double navBarIconSize);

  LauncherTheme longPressActionDuration(Duration longPressActionDuration);

  LauncherTheme appGridTheme(AppGridTheme appGridTheme);

  LauncherTheme pageIndicatorTheme(PageIndicatorTheme pageIndicatorTheme);

  LauncherTheme settingsTheme(SettingsTheme settingsTheme);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `LauncherTheme(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LauncherTheme(...).copyWith(id: 12, name: "My name")
  /// ```
  LauncherTheme call({
    Color uiPrimaryColour,
    double navBarHeight,
    double navBarSpacing,
    double navBarIconSize,
    Duration longPressActionDuration,
    AppGridTheme appGridTheme,
    PageIndicatorTheme pageIndicatorTheme,
    SettingsTheme settingsTheme,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLauncherTheme.copyWith(...)` or call `instanceOfLauncherTheme.copyWith.fieldName(value)` for a single field.
class _$LauncherThemeCWProxyImpl implements _$LauncherThemeCWProxy {
  const _$LauncherThemeCWProxyImpl(this._value);

  final LauncherTheme _value;

  @override
  LauncherTheme uiPrimaryColour(Color uiPrimaryColour) =>
      call(uiPrimaryColour: uiPrimaryColour);

  @override
  LauncherTheme navBarHeight(double navBarHeight) =>
      call(navBarHeight: navBarHeight);

  @override
  LauncherTheme navBarSpacing(double navBarSpacing) =>
      call(navBarSpacing: navBarSpacing);

  @override
  LauncherTheme navBarIconSize(double navBarIconSize) =>
      call(navBarIconSize: navBarIconSize);

  @override
  LauncherTheme longPressActionDuration(Duration longPressActionDuration) =>
      call(longPressActionDuration: longPressActionDuration);

  @override
  LauncherTheme appGridTheme(AppGridTheme appGridTheme) =>
      call(appGridTheme: appGridTheme);

  @override
  LauncherTheme pageIndicatorTheme(PageIndicatorTheme pageIndicatorTheme) =>
      call(pageIndicatorTheme: pageIndicatorTheme);

  @override
  LauncherTheme settingsTheme(SettingsTheme settingsTheme) =>
      call(settingsTheme: settingsTheme);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `LauncherTheme(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LauncherTheme(...).copyWith(id: 12, name: "My name")
  /// ```
  LauncherTheme call({
    Object? uiPrimaryColour = const $CopyWithPlaceholder(),
    Object? navBarHeight = const $CopyWithPlaceholder(),
    Object? navBarSpacing = const $CopyWithPlaceholder(),
    Object? navBarIconSize = const $CopyWithPlaceholder(),
    Object? longPressActionDuration = const $CopyWithPlaceholder(),
    Object? appGridTheme = const $CopyWithPlaceholder(),
    Object? pageIndicatorTheme = const $CopyWithPlaceholder(),
    Object? settingsTheme = const $CopyWithPlaceholder(),
  }) {
    return LauncherTheme(
      uiPrimaryColour:
          uiPrimaryColour == const $CopyWithPlaceholder() ||
              uiPrimaryColour == null
          ? _value.uiPrimaryColour
          // ignore: cast_nullable_to_non_nullable
          : uiPrimaryColour as Color,
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
      longPressActionDuration:
          longPressActionDuration == const $CopyWithPlaceholder() ||
              longPressActionDuration == null
          ? _value.longPressActionDuration
          // ignore: cast_nullable_to_non_nullable
          : longPressActionDuration as Duration,
      appGridTheme:
          appGridTheme == const $CopyWithPlaceholder() || appGridTheme == null
          ? _value.appGridTheme
          // ignore: cast_nullable_to_non_nullable
          : appGridTheme as AppGridTheme,
      pageIndicatorTheme:
          pageIndicatorTheme == const $CopyWithPlaceholder() ||
              pageIndicatorTheme == null
          ? _value.pageIndicatorTheme
          // ignore: cast_nullable_to_non_nullable
          : pageIndicatorTheme as PageIndicatorTheme,
      settingsTheme:
          settingsTheme == const $CopyWithPlaceholder() || settingsTheme == null
          ? _value.settingsTheme
          // ignore: cast_nullable_to_non_nullable
          : settingsTheme as SettingsTheme,
    );
  }
}

extension $LauncherThemeCopyWith on LauncherTheme {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLauncherTheme.copyWith(...)` or `instanceOfLauncherTheme.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LauncherThemeCWProxy get copyWith => _$LauncherThemeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LauncherTheme _$LauncherThemeFromJson(Map<String, dynamic> json) =>
    LauncherTheme(
      uiPrimaryColour: json['uiPrimaryColour'] == null
          ? const Color(0xFFe6e6e6)
          : const ColourConverter().fromJson(json['uiPrimaryColour'] as String),
      navBarHeight: (json['navBarHeight'] as num?)?.toDouble() ?? 82,
      navBarSpacing: (json['navBarSpacing'] as num?)?.toDouble() ?? 16,
      navBarIconSize: (json['navBarIconSize'] as num?)?.toDouble() ?? 48,
      longPressActionDuration: json['longPressActionDuration'] == null
          ? const Duration(milliseconds: 800)
          : Duration(
              microseconds: (json['longPressActionDuration'] as num).toInt(),
            ),
      appGridTheme: json['appGridTheme'] == null
          ? const AppGridTheme()
          : AppGridTheme.fromJson(json['appGridTheme'] as Map<String, dynamic>),
      pageIndicatorTheme: json['pageIndicatorTheme'] == null
          ? const PageIndicatorTheme()
          : PageIndicatorTheme.fromJson(
              json['pageIndicatorTheme'] as Map<String, dynamic>,
            ),
      settingsTheme: json['settingsTheme'] == null
          ? const SettingsTheme()
          : SettingsTheme.fromJson(
              json['settingsTheme'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$LauncherThemeToJson(
  LauncherTheme instance,
) => <String, dynamic>{
  'navBarHeight': instance.navBarHeight,
  'navBarIconSize': instance.navBarIconSize,
  'navBarSpacing': instance.navBarSpacing,
  'uiPrimaryColour': const ColourConverter().toJson(instance.uiPrimaryColour),
  'longPressActionDuration': instance.longPressActionDuration.inMicroseconds,
  'appGridTheme': instance.appGridTheme,
  'pageIndicatorTheme': instance.pageIndicatorTheme,
  'settingsTheme': instance.settingsTheme,
};

const _$LauncherThemeJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'navBarHeight': {'type': 'number', 'default': 82.0},
    'navBarIconSize': {'type': 'number', 'default': 48.0},
    'navBarSpacing': {'type': 'number', 'default': 16.0},
    'uiPrimaryColour': {r'$ref': r'#/$defs/Color'},
    'longPressActionDuration': {r'$ref': r'#/$defs/Duration'},
    'appGridTheme': {r'$ref': r'#/$defs/AppGridTheme'},
    'pageIndicatorTheme': {r'$ref': r'#/$defs/PageIndicatorTheme'},
    'settingsTheme': {r'$ref': r'#/$defs/SettingsTheme'},
  },
  r'$defs': {
    'Color': {
      'type': 'object',
      'properties': {
        'value': {'type': 'integer'},
      },
      'required': ['value'],
    },
    'Duration': {'type': 'object', 'properties': {}},
    'EdgeInsets': {'type': 'object', 'properties': {}},
    'SelectorTheme': {
      'type': 'object',
      'properties': {
        'selectorBackgroundColour': {r'$ref': r'#/$defs/Color'},
        'selectorBorderColour': {r'$ref': r'#/$defs/Color'},
        'selectorBorderRadius': {'type': 'number', 'default': 0.0},
      },
    },
    'GradientTransform': {'type': 'object', 'properties': {}},
    'Gradient': {
      'type': 'object',
      'properties': {
        'colors': {
          'type': 'array',
          'items': {r'$ref': r'#/$defs/Color'},
          'description':
              "The colors the gradient should obtain at each of the stops.\n\nIf [stops] is non-null, this list must have the same length as [stops].\n\nThis list must have at least two colors in it (otherwise, it's not a\ngradient!).",
        },
        'stops': {
          'type': 'array',
          'items': {'type': 'number'},
          'description':
              'A list of values from 0.0 to 1.0 that denote fractions along the gradient.\n\nIf non-null, this list must have the same length as [colors].\n\nIf the first value is not 0.0, then a stop with position 0.0 and a color\nequal to the first color in [colors] is implied.\n\nIf the last value is not 1.0, then a stop with position 1.0 and a color\nequal to the last color in [colors] is implied.\n\nThe values in the [stops] list must be in ascending order. If a value in\nthe [stops] list is less than an earlier value in the list, then its value\nis assumed to equal the previous value.\n\nIf stops is null, then a set of uniformly distributed stops is implied,\nwith the first stop at 0.0 and the last stop at 1.0.',
        },
        'transform': {
          r'$ref': r'#/$defs/GradientTransform',
          'description':
              'The transform, if any, to apply to the gradient.\n\nThis transform is in addition to any other transformations applied to the\ncanvas, but does not add any transformations to the canvas.',
        },
      },
      'required': ['colors'],
    },
    'AppGridTheme': {
      'type': 'object',
      'properties': {
        'columns': {'type': 'integer', 'default': 5},
        'rows': {'type': 'integer', 'default': 3},
        'iconSize': {'type': 'number', 'default': 68.0},
        'appCardFontSize': {'type': 'number', 'default': 18.0},
        'appCardTextOutlineColour': {r'$ref': r'#/$defs/Color'},
        'appGridOutterPadding': {r'$ref': r'#/$defs/EdgeInsets'},
        'appCardIconPadding': {r'$ref': r'#/$defs/EdgeInsets'},
        'columnSpacing': {'type': 'number', 'default': 10.0},
        'rowSpacing': {'type': 'number', 'default': 10.0},
        'appGridEdgeHoverZoneWidth': {'type': 'number', 'default': 70.0},
        'appGridEdgeHoverDuration': {r'$ref': r'#/$defs/Duration'},
        'appCardBackgroundColour': {r'$ref': r'#/$defs/Color'},
        'cornerRadius': {'type': 'number', 'default': 0.0},
        'selectorTheme': {r'$ref': r'#/$defs/SelectorTheme'},
        'appCardGradient': {r'$ref': r'#/$defs/Gradient'},
      },
    },
    'PageIndicatorTheme': {
      'type': 'object',
      'properties': {
        'pageIndicatorInactiveSize': {'type': 'number', 'default': 12.0},
        'pageIndicatorActiveSize': {'type': 'number', 'default': 22.0},
        'pageIndicatorSpacing': {'type': 'number', 'default': 28.0},
        'pageIndicatorFontSize': {'type': 'number', 'default': 14.0},
        'pageIndicatorTextColour': {r'$ref': r'#/$defs/Color'},
        'indicatorShape': {'type': 'object'},
      },
    },
    'SettingsTheme': {
      'type': 'object',
      'properties': {
        'menuItemTitleFontSize': {'type': 'number', 'default': 28.0},
        'menuItemBodyFontSize': {'type': 'number', 'default': 22.0},
        'menuItemBorderColour': {r'$ref': r'#/$defs/Color'},
        'menuItemTitleTextColour': {r'$ref': r'#/$defs/Color'},
        'menuItemBodyTextColour': {r'$ref': r'#/$defs/Color'},
        'menuItemTitleSelectedTextColour': {r'$ref': r'#/$defs/Color'},
        'menuItemBodySelectedTextColour': {r'$ref': r'#/$defs/Color'},
        'backgroundColour': {r'$ref': r'#/$defs/Color'},
        'selectorTheme': {r'$ref': r'#/$defs/SelectorTheme'},
      },
    },
  },
};
