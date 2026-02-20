import 'dart:async';

import 'package:classiclauncher/handlers/selector_handler.dart';
import 'package:classiclauncher/handlers/theme_handler.dart';
import 'package:classiclauncher/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectorContainer extends StatefulWidget {
  final String selectorKey;
  final Widget child;
  const SelectorContainer({super.key, required this.selectorKey, required this.child});

  @override
  State<SelectorContainer> createState() => _SelectorContainerState();
}

class _SelectorContainerState extends State<SelectorContainer> {
  final ThemeHandler themeHandler = Get.find<ThemeHandler>();
  final SelectorHandler selectorHandler = Get.find<SelectorHandler>();
  bool selected = false;
  bool buttonPressed = false;

  @override
  void initState() {
    selected = selectorHandler.selectedKey.value == widget.selectorKey;

    super.initState();

    ever(selectorHandler.selectedKey, (String? newKey) {
      if (!mounted) {
        return;
      }
      bool newSelected = newKey == widget.selectorKey;
      if (newSelected != selected) {
        setState(() {
          selected = newSelected;
        });
      }
    });

    ever(selectorHandler.heldInputs, (Map<Input, Timer> inputMap) {
      if (!mounted) {
        return;
      }
      bool newButtonPressed = selectorHandler.heldInputs.containsKey(Input.select);
      if (newButtonPressed != buttonPressed) {
        setState(() {
          buttonPressed = newButtonPressed;
        });
      }
    });
  }

  Color getHoldColour(Color colour) {
    Color whiter = Color.lerp(colour, Colors.white, 0.1)!;
    return whiter.withValues(alpha: (colour.a * 0.8));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectorHandler.handleWidgetPress(widgetKey: widget.selectorKey);
      },

      child: Container(
        decoration: selected
            ? buttonPressed
                  ? themeHandler.theme.value.selectorDecoration.copyWith(color: getHoldColour(themeHandler.theme.value.selectorDecoration.color!))
                  : themeHandler.theme.value.selectorDecoration
            : null,
        child: Stack(
          children: [
            Align(alignment: Alignment.center, child: widget.child),

            // Text(widget.selectorKey.split("_")[1], style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
