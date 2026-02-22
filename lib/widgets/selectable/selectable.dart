import 'package:classiclauncher/models/enums.dart';
import 'package:classiclauncher/models/key_press.dart';
import 'package:classiclauncher/widgets/selectable/selectable_controller.dart';
import 'package:flutter/material.dart';

abstract class SelectableZone {
  late String zoneKey;
  int currentIndex = 0;
  int? preferredZoneIndex;

  // returns new index. -1 is no move
  int handleMove(Direction direction, MoveType moveType);
}

class Selectable extends InheritedWidget {
  final SelectableController controller;
  const Selectable({super.key, required super.child, required this.controller});

  static Selectable of(BuildContext context) {
    final Selectable? result = context.dependOnInheritedWidgetOfExactType<Selectable>();
    assert(result != null, 'No Selectable found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Selectable oldWidget) {
    return controller != oldWidget.controller;
  }
}
