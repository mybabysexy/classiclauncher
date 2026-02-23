import 'package:classiclauncher/handlers/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum IndicatorShape { circle, squircle }

class PageIndicators extends StatefulWidget {
  final int pageCount;
  final ValueNotifier<int> selected;
  final void Function(int page)? onPageSelected;

  const PageIndicators({super.key, required this.selected, required this.pageCount, this.onPageSelected});

  @override
  State<PageIndicators> createState() => _PageIndicatorsState();
}

class _PageIndicatorsState extends State<PageIndicators> {
  ThemeHandler themeHandler = Get.find<ThemeHandler>();
  late int selected;
  final GlobalKey _rowKey = GlobalKey();

  @override
  void initState() {
    selected = widget.selected.value;

    widget.selected.addListener(() {
      if (widget.selected.value != selected && mounted) {
        setState(() {
          selected = widget.selected.value;
        });
      }
    });
    super.initState();
  }

  void _selectFromLocalX(double localX) {
    final RenderBox? box = _rowKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final double totalWidth = box.size.width;
    final double dotWidth = totalWidth / widget.pageCount;
    final int page = (localX / dotWidth).floor().clamp(0, widget.pageCount - 1);
    if (page != selected) {
      widget.onPageSelected?.call(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    int maxDots = 5;
    int dotCount = widget.pageCount.clamp(0, maxDots);
    int activeDot = selected % maxDots;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) => _selectFromLocalX(details.localPosition.dx),
      onHorizontalDragUpdate: (details) => _selectFromLocalX(details.localPosition.dx),
      child: Row(
        key: _rowKey,
        children: [
          for (int i = 0; i < dotCount; i++)
            Padding(
              padding: EdgeInsets.only(right: i == dotCount - 1 ? 0 : themeHandler.theme.value.pageIndicatorTheme.pageIndicatorSpacing),
              child: PageIndicator(key: ValueKey("PageIndicators::$i"), pageNumber: i == activeDot ? selected : i, selected: i == activeDot),
            ),
        ],
      ),
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
