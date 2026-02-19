import 'package:classiclauncher/models/launcher_theme.dart';
import 'package:get/get.dart';

class ThemeHandler extends GetxController {
  Rx<LauncherTheme> theme = Rx(LauncherTheme());

  double getCardHeight({required double gridHeight}) {
    return (gridHeight - theme.value.gridOutterTopsSize - (theme.value.rowSpacing * (theme.value.rows - 1))) / theme.value.rows;
  }

  double getCardWidth({required double gridWidth}) {
    return (gridWidth - theme.value.gridOutterSideSize - (theme.value.columnSpacing * (theme.value.columns - 1))) / theme.value.columns;
  }
}
