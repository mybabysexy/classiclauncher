import 'package:classiclauncher/selector_handler.dart';
import 'package:classiclauncher/theme_handler.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectorHandler.handleWidgetPress(widgetKey: widget.selectorKey);
      },

      child: Container(
        decoration: selected ? themeHandler.theme.value.selectorDecoration : null,
        child: Stack(
          children: [
            widget.child,
            // Text(widget.selectorKey.split("_")[1], style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
