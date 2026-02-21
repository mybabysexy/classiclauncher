// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launcher_theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LauncherTheme _$LauncherThemeFromJson(Map<String, dynamic> json) =>
    LauncherTheme(
      columns: (json['columns'] as num?)?.toInt() ?? 5,
      rows: (json['rows'] as num?)?.toInt() ?? 3,
      iconSize: (json['iconSize'] as num?)?.toDouble() ?? 68,
      rowSpacing: (json['rowSpacing'] as num?)?.toDouble() ?? 10,
      columnSpacing: (json['columnSpacing'] as num?)?.toDouble() ?? 10,
      appGridOutterPadding: json['appGridOutterPadding'] == null
          ? const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 12)
          : const EdgeInsetsConverter().fromJson(
              json['appGridOutterPadding'] as Map<String, dynamic>,
            ),
      uiPrimaryColour: json['uiPrimaryColour'] == null
          ? const Color(0xFFe6e6e6)
          : const ColourConverter().fromJson(json['uiPrimaryColour'] as String),
      navBarHeight: (json['navBarHeight'] as num?)?.toDouble() ?? 82,
      navBarSpacing: (json['navBarSpacing'] as num?)?.toDouble() ?? 16,
      navBarIconSize: (json['navBarIconSize'] as num?)?.toDouble() ?? 48,
      appCardIconPadding: json['appCardIconPadding'] == null
          ? const EdgeInsets.only(bottom: 20, left: 8, right: 8, top: 8)
          : const EdgeInsetsConverter().fromJson(
              json['appCardIconPadding'] as Map<String, dynamic>,
            ),
      pageIndicatorInactiveSize:
          (json['pageIndicatorInactiveSize'] as num?)?.toDouble() ?? 12,
      pageIndicatorActiveSize:
          (json['pageIndicatorActiveSize'] as num?)?.toDouble() ?? 22,
      pageIndicatorSpacing:
          (json['pageIndicatorSpacing'] as num?)?.toDouble() ?? 28,
      pageIndicatorFontSize:
          (json['pageIndicatorFontSize'] as num?)?.toDouble() ?? 14,
      appGridEdgeHoverDuration: json['appGridEdgeHoverDuration'] == null
          ? const Duration(milliseconds: 2500)
          : Duration(
              microseconds: (json['appGridEdgeHoverDuration'] as num).toInt(),
            ),
      appGridEdgeHoverZoneWidth:
          (json['appGridEdgeHoverZoneWidth'] as num?)?.toDouble() ?? 70,
      longPressActionDuration: json['longPressActionDuration'] == null
          ? const Duration(milliseconds: 800)
          : Duration(
              microseconds: (json['longPressActionDuration'] as num).toInt(),
            ),
      appCardFontSize: (json['appCardFontSize'] as num?)?.toDouble() ?? 18,
      appCardTextOutlineColour: json['appCardTextOutlineColour'] == null
          ? Colors.black
          : const ColourConverter().fromJson(
              json['appCardTextOutlineColour'] as String,
            ),
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
      pageIndicatorTextColour: json['pageIndicatorTextColour'] == null
          ? Colors.black
          : const ColourConverter().fromJson(
              json['pageIndicatorTextColour'] as String,
            ),
    );

Map<String, dynamic> _$LauncherThemeToJson(
  LauncherTheme instance,
) => <String, dynamic>{
  'columns': instance.columns,
  'rows': instance.rows,
  'iconSize': instance.iconSize,
  'appCardFontSize': instance.appCardFontSize,
  'appCardTextOutlineColour': const ColourConverter().toJson(
    instance.appCardTextOutlineColour,
  ),
  'appGridOutterPadding': const EdgeInsetsConverter().toJson(
    instance.appGridOutterPadding,
  ),
  'appCardIconPadding': const EdgeInsetsConverter().toJson(
    instance.appCardIconPadding,
  ),
  'columnSpacing': instance.columnSpacing,
  'rowSpacing': instance.rowSpacing,
  'navBarHeight': instance.navBarHeight,
  'navBarIconSize': instance.navBarIconSize,
  'navBarSpacing': instance.navBarSpacing,
  'pageIndicatorInactiveSize': instance.pageIndicatorInactiveSize,
  'pageIndicatorActiveSize': instance.pageIndicatorActiveSize,
  'pageIndicatorSpacing': instance.pageIndicatorSpacing,
  'pageIndicatorFontSize': instance.pageIndicatorFontSize,
  'pageIndicatorTextColour': const ColourConverter().toJson(
    instance.pageIndicatorTextColour,
  ),
  'uiPrimaryColour': const ColourConverter().toJson(instance.uiPrimaryColour),
  'selectorBackgroundColour': const ColourConverter().toJson(
    instance.selectorBackgroundColour,
  ),
  'selectorBorderColour': const ColourConverter().toJson(
    instance.selectorBorderColour,
  ),
  'selectorBorderRadius': instance.selectorBorderRadius,
  'appGridEdgeHoverDuration': instance.appGridEdgeHoverDuration.inMicroseconds,
  'longPressActionDuration': instance.longPressActionDuration.inMicroseconds,
  'appGridEdgeHoverZoneWidth': instance.appGridEdgeHoverZoneWidth,
};

const _$LauncherThemeJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
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
    'navBarHeight': {'type': 'number', 'default': 82.0},
    'navBarIconSize': {'type': 'number', 'default': 48.0},
    'navBarSpacing': {'type': 'number', 'default': 16.0},
    'pageIndicatorInactiveSize': {'type': 'number', 'default': 12.0},
    'pageIndicatorActiveSize': {'type': 'number', 'default': 22.0},
    'pageIndicatorSpacing': {'type': 'number', 'default': 28.0},
    'pageIndicatorFontSize': {'type': 'number', 'default': 14.0},
    'pageIndicatorTextColour': {r'$ref': r'#/$defs/Color'},
    'uiPrimaryColour': {r'$ref': r'#/$defs/Color'},
    'selectorBackgroundColour': {r'$ref': r'#/$defs/Color'},
    'selectorBorderColour': {r'$ref': r'#/$defs/Color'},
    'selectorBorderRadius': {'type': 'number', 'default': 0.0},
    'appGridEdgeHoverDuration': {r'$ref': r'#/$defs/Duration'},
    'longPressActionDuration': {r'$ref': r'#/$defs/Duration'},
    'appGridEdgeHoverZoneWidth': {'type': 'number', 'default': 70.0},
  },
  r'$defs': {
    'Color': {
      'type': 'object',
      'properties': {
        'value': {'type': 'integer'},
      },
      'required': ['value'],
    },
    'EdgeInsets': {'type': 'object', 'properties': {}},
    'Duration': {'type': 'object', 'properties': {}},
  },
};
