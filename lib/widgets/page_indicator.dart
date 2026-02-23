import 'package:classiclauncher/handlers/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum IndicatorShape { circle, squircle }

class PageIndicators extends StatefulWidget {
  final int pageCount;
  final ValueNotifier<int> selected;

  const PageIndicators({super.key, required this.selected, required this.pageCount});

  @override
  State<PageIndicators> createState() => _PageIndicatorsState();
}

class _PageIndicatorsState extends State<PageIndicators> {
  ThemeHandler themeHandler = Get.find<ThemeHandler>();
  late int selected;

  @override
  void initState() {
    selected = widget.selected.value;

    widget.selected.addListener(() {
      if (widget.selected.value != selected) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            selected = widget.selected.value;
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int maxDots = 5;
    int dotCount = widget.pageCount.clamp(0, maxDots);
    int activeDot = selected % maxDots;

    return Row(
      children: [
        for (int i = 0; i < dotCount; i++)
          Padding(
            padding: EdgeInsets.only(right: i == dotCount - 1 ? 0 : themeHandler.theme.value.pageIndicatorTheme.pageIndicatorSpacing),
            child: PageIndicator(key: ValueKey("PageIndicators::$i"), pageNumber: i == activeDot ? selected : i, selected: i == activeDot),
          ),
      ],
    );
  }
}

class PageIndicator extends StatefulWidget {
  final int pageNumber;
  final bool selected;
  const PageIndicator({super.key, required this.pageNumber, required this.selected});

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  ThemeHandler themeHandler = Get.find<ThemeHandler>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: themeHandler.theme.value.pageIndicatorTheme.pageIndicatorActiveSize,
      height: themeHandler.theme.value.pageIndicatorTheme.pageIndicatorActiveSize,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              width: widget.selected
                  ? themeHandler.theme.value.pageIndicatorTheme.pageIndicatorActiveSize
                  : themeHandler.theme.value.pageIndicatorTheme.pageIndicatorInactiveSize,
              height: widget.selected
                  ? themeHandler.theme.value.pageIndicatorTheme.pageIndicatorActiveSize
                  : themeHandler.theme.value.pageIndicatorTheme.pageIndicatorInactiveSize,
              key: ValueKey("PageIndicator::AnimatedContainer::${widget.pageNumber}"),
              decoration: themeHandler.theme.value.pageIndicatorTheme.indicatorShape == IndicatorShape.squircle
                  ? ShapeDecoration(
                      color: themeHandler.theme.value.pageIndicatorTheme.pageIndicatorColour,
                      shadows: [BoxShadow(color: Colors.black38, blurRadius: 5, offset: const Offset(0, 2))],
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                    )
                  : BoxDecoration(
                      color: themeHandler.theme.value.pageIndicatorTheme.pageIndicatorColour,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                      boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 5, offset: const Offset(0, 2))],
                    ),
              duration: const Duration(milliseconds: 100),
            ),
          ),
          if (widget.selected)
            Align(
              alignment: Alignment.center,
              child: Text(
                (widget.pageNumber + 1).toString(),
                style: themeHandler.theme.value.pageIndicatorTheme.pageIndicatorTextStyle,
                textAlign: TextAlign.center,
                strutStyle: const StrutStyle(forceStrutHeight: true, height: 1.0),
              ),
            ),
        ],
      ),
    );
  }
}
