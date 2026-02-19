import 'package:classiclauncher/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageIndicators extends StatefulWidget {
  final PageController controller;
  final int pageCount;

  const PageIndicators({super.key, required this.controller, required this.pageCount});

  @override
  State<PageIndicators> createState() => _PageIndicatorsState();
}

class _PageIndicatorsState extends State<PageIndicators> {
  ThemeHandler themeHandler = Get.find<ThemeHandler>();
  int selectedPage = 0;
  @override
  void initState() {
    widget.controller.addListener(() {
      if (!mounted) {
        return;
      }

      double? newPage = widget.controller.page;

      if (newPage == null) {
        return;
      }

      if (newPage.round() != selectedPage) {
        setState(() {
          selectedPage = newPage.round();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < widget.pageCount; i++)
          Padding(
            padding: EdgeInsets.only(right: i == widget.pageCount - 1 ? 0 : themeHandler.theme.value.pageIndicatorSpacing),
            child: PageIndicator(key: ValueKey("PageIndicators::$i"), pageNumber: i, selected: i == selectedPage),
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
      width: themeHandler.theme.value.pageIndicatorActiveSize,
      height: themeHandler.theme.value.pageIndicatorActiveSize,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              width: widget.selected ? themeHandler.theme.value.pageIndicatorActiveSize : themeHandler.theme.value.pageIndicatorInactiveSize,
              height: widget.selected ? themeHandler.theme.value.pageIndicatorActiveSize : themeHandler.theme.value.pageIndicatorInactiveSize,

              key: ValueKey("PageIndicator::AnimatedContainer::${widget.pageNumber}"),
              decoration: BoxDecoration(
                color: themeHandler.theme.value.uiPrimaryColour,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 1, // 1 logical pixel
                ),
                boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 5, offset: const Offset(0, 2))],
              ),
              duration: Duration(milliseconds: 100),
            ),
          ),
          if (widget.selected)
            Align(
              alignment: Alignment.center,
              child: Text(
                (widget.pageNumber + 1).toString(),
                style: themeHandler.theme.value.pageIndicatorTextStyle,
                textAlign: TextAlign.center,
                strutStyle: const StrutStyle(forceStrutHeight: true, height: 1.0),
              ),
            ),
        ],
      ),
    );
  }
}
